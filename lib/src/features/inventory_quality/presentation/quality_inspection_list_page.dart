import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/approval_rejection_notice_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/attachment_open_button.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/inventory_quality/application/quality_inspection_view_model.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_api_service.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection_repository.dart';

/// 质检列表入口。
class QualityInspectionListEntry extends StatelessWidget {
  const QualityInspectionListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<QualityInspectionApiService,
        QualityInspectionRepository, QualityInspectionViewModel>(
      createService: (context) =>
          QualityInspectionApiService(context.read<ApiClient>()),
      createRepository: (context) => QualityInspectionRepositoryImpl(
        context.read<QualityInspectionApiService>(),
      ),
      createViewModel: (context) => QualityInspectionViewModel(
          context.read<QualityInspectionRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const QualityInspectionListPage(),
    );
  }
}

/// 质检列表页视图，只负责渲染。
class QualityInspectionListPage extends StatelessWidget {
  const QualityInspectionListPage({super.key});

  @override
  Widget build(BuildContext context) => const _QualityInspectionListView();
}

class _QualityInspectionListView extends StatefulWidget {
  const _QualityInspectionListView();

  @override
  State<_QualityInspectionListView> createState() =>
      _QualityInspectionListViewState();
}

class _QualityInspectionListViewState
    extends State<_QualityInspectionListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索检验单号/施工单号';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无质检数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _completeTitle = '完成检验';
  static const String _completeSuccessText = '检验完成';
  static const String _completeErrorText = '检验提交失败: ';
  static const String _submitText = '提交';
  static const String _cancelText = '取消';
  static const String _detailTitle = '质检详情';
  static const String _resultFilterLabel = '检验结果';
  static const String _typeFilterLabel = '检验类型';
  static const String _resetButtonText = '重置筛选';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';
  static const List<String> _attachmentExtensions = [
    'pdf',
    'png',
    'jpg',
    'jpeg',
  ];

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  int? _uploadingInspectionId;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(QualityInspectionViewModel viewModel,
      {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadInspections(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadInspections(resetPage: true);
    });
  }

  Future<void> _openDetailDialog(QualityInspection inspection) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(_detailTitle),
          content: SizedBox(
            width: 640,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_needsExceptionFollowUp(inspection)) ...[
                    ApprovalRejectionNoticeCard(
                      title: inspection.result == 'failed'
                          ? '质检未通过，需要处理'
                          : '质检为条件接收，需要跟进',
                      icon: Icons.report_problem_outlined,
                      reasonLabel: '问题摘要',
                      reason: _qualityIssueSummary(inspection),
                      commentLabel: '处理意见',
                      comment: _qualityDispositionComment(inspection),
                      nextStepLabel: '建议动作',
                      nextStep: _qualityNextStep(inspection),
                      primaryAction: OutlinedButton.icon(
                        onPressed: () => _uploadAttachment(
                          context.read<QualityInspectionViewModel>(),
                          inspection,
                        ),
                        icon: const Icon(Icons.upload_file_outlined, size: 18),
                        label: Text(
                          _hasAttachment(inspection) ? '更新附件' : '上传附件',
                        ),
                      ),
                      secondaryAction: inspection.workOrderId == null
                          ? null
                          : FilledButton.icon(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                context.go(
                                    '/workorders/${inspection.workOrderId}');
                              },
                              icon: const Icon(Icons.open_in_new, size: 18),
                              label: const Text('查看施工单'),
                            ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _DetailRow(label: '质检单号', value: inspection.inspectionNumber),
                  _DetailRow(
                    label: '检验类型',
                    value: _displayText(inspection.inspectionTypeDisplay ??
                        inspection.inspectionType),
                  ),
                  _DetailRow(
                    label: '产品',
                    value: _displayText(inspection.productName),
                  ),
                  _DetailRow(
                    label: '批次号',
                    value: _displayText(inspection.batchNo),
                  ),
                  _DetailRow(
                    label: '施工单号',
                    value: _displayText(inspection.workOrderNumber),
                  ),
                  _DetailRow(
                    label: '检验员',
                    value: _displayText(inspection.inspectorName),
                  ),
                  _DetailRow(
                    label: '检验日期',
                    value: _formatDate(inspection.inspectionDate),
                  ),
                  _DetailRow(
                    label: '检验数量',
                    value: _formatAmount(inspection.inspectionQuantity),
                  ),
                  _DetailRow(
                    label: '合格数量',
                    value: _formatAmount(inspection.passedQuantity),
                  ),
                  _DetailRow(
                    label: '不合格数量',
                    value: _formatAmount(inspection.failedQuantity),
                  ),
                  _DetailRow(
                    label: '检验结果',
                    value: _displayText(
                        inspection.resultDisplay ?? inspection.result),
                  ),
                  _DetailRow(
                    label: '检验附件',
                    value: _hasAttachment(inspection) ? '已上传' : _emptyCellText,
                  ),
                  if ((inspection.inspectionStandard ?? '').trim().isNotEmpty)
                    _DetailRow(
                      label: '检验标准',
                      value: inspection.inspectionStandard ?? '',
                    ),
                  if (inspection.inspectionItems.isNotEmpty)
                    _DetailRow(
                      label: '检验项目',
                      value: inspection.inspectionItems.join('、'),
                    ),
                  if (inspection.defects.isNotEmpty)
                    _DetailRow(
                      label: '缺陷',
                      value: inspection.defects.join('、'),
                    ),
                  if ((inspection.defectDescription ?? '').trim().isNotEmpty)
                    _DetailRow(
                      label: '缺陷描述',
                      value: inspection.defectDescription ?? '',
                    ),
                  if ((inspection.disposition ?? '').trim().isNotEmpty)
                    _DetailRow(
                      label: '处理意见',
                      value: inspection.disposition ?? '',
                    ),
                  if ((inspection.dispositionNotes ?? '').trim().isNotEmpty)
                    _DetailRow(
                      label: '处理备注',
                      value: inspection.dispositionNotes ?? '',
                    ),
                  if ((inspection.notes ?? '').trim().isNotEmpty)
                    _DetailRow(label: '备注', value: inspection.notes ?? ''),
                ],
              ),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => _uploadAttachment(
                context.read<QualityInspectionViewModel>(),
                inspection,
              ),
              icon: const Icon(Icons.upload_file_outlined, size: 18),
              label: Text(_hasAttachment(inspection) ? '更新附件' : '上传附件'),
            ),
            if (_hasAttachment(inspection))
              AttachmentOpenButton(
                fileUrl: inspection.attachmentUrl,
                label: '查看附件',
                errorPrefix: '打开检验附件失败',
              ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(_cancelText),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openCompleteDialog(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    QualityInspection inspection,
  ) async {
    final apiService = context.read<QualityInspectionApiService>();
    final formKey = GlobalKey<FormState>();
    final passedController = TextEditingController(
      text: inspection.passedQuantity?.toStringAsFixed(0) ?? '',
    );
    final failedController = TextEditingController(
      text: inspection.failedQuantity?.toStringAsFixed(0) ?? '',
    );
    String result = inspection.result == null || inspection.result == 'pending'
        ? 'passed'
        : inspection.result!;
    bool submitting = false;

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      final passedText = passedController.text.trim();
      final failedText = failedController.text.trim();
      final passed = int.tryParse(passedText);
      final failed = int.tryParse(failedText);
      if (passed == null || failed == null) {
        ToastUtil.showError('请输入有效数量');
        return;
      }
      setState(() => submitting = true);
      try {
        await apiService.complete(inspection.id, {
          'result': result,
          'passed_quantity': passed,
          'failed_quantity': failed,
        });
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtil.showSuccess(_completeSuccessText);
        await viewModel.loadInspections(resetPage: false);
      } catch (err) {
        if (!mounted) return;
        setState(() => submitting = false);
        ToastUtil.showError('$_completeErrorText$err');
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(_completeTitle),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SearchableDropdownFormField<String>(
                          key: ValueKey<String>(result),
                          initialValue: result,
                          decoration: const InputDecoration(labelText: '检验结果'),
                          items: const [
                            DropdownMenuItem(
                                value: 'passed', child: Text('合格')),
                            DropdownMenuItem(
                                value: 'failed', child: Text('不合格')),
                            DropdownMenuItem(
                                value: 'conditional', child: Text('条件接收')),
                          ],
                          onChanged: submitting
                              ? null
                              : (value) {
                                  if (value == null) return;
                                  setState(() => result = value);
                                },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: passedController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: '合格数量'),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            final parsed = int.tryParse(text);
                            if (parsed == null || parsed < 0) {
                              return '请输入有效数量';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: failedController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: '不合格数量'),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            final parsed = int.tryParse(text);
                            if (parsed == null || parsed < 0) {
                              return '请输入有效数量';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(_cancelText),
                ),
                FilledButton(
                  onPressed: submitting ? null : () => submit(setState),
                  child: Text(submitting ? '提交中...' : _submitText),
                ),
              ],
            );
          },
        );
      },
    );

    passedController.dispose();
    failedController.dispose();
  }

  Future<void> _uploadAttachment(
    QualityInspectionViewModel viewModel,
    QualityInspection inspection,
  ) async {
    if (_uploadingInspectionId == inspection.id) {
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _attachmentExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }

    final picked = result.files.single;
    final fileName =
        picked.name.trim().isEmpty ? 'quality-attachment' : picked.name;
    MultipartFile attachment;
    final bytes = picked.bytes;

    if (bytes != null && bytes.isNotEmpty) {
      attachment = MultipartFile.fromBytes(bytes, filename: fileName);
    } else if ((picked.path ?? '').trim().isNotEmpty) {
      attachment =
          await MultipartFile.fromFile(picked.path!.trim(), filename: fileName);
    } else {
      ToastUtil.showError('无法读取所选文件');
      return;
    }

    setState(() => _uploadingInspectionId = inspection.id);
    try {
      await viewModel.uploadAttachment(inspection.id, attachment);
      if (!mounted) return;
      ToastUtil.showSuccess('检验附件已上传');
      await viewModel.loadInspections(resetPage: false);
    } catch (err) {
      ToastUtil.showError('上传检验附件失败: $err');
    } finally {
      if (mounted && _uploadingInspectionId == inspection.id) {
        setState(() => _uploadingInspectionId = null);
      }
    }
  }

  static String _pageInfoText(QualityInspectionViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<QualityInspectionViewModel>(
      builder: (context, viewModel, _) {
        final inspections = viewModel.inspections;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, inspections, isMobile),
          footer: viewModel.totalPages > 1
              ? ResponsivePaginationBar(
                  infoText: _pageInfoText(viewModel),
                  page: viewModel.page,
                  pageSize: viewModel.pageSize,
                  pageSizeOptions: viewModel.pageSizeOptions,
                  onPageSizeChanged: viewModel.setPageSize,
                  onPrev: () => viewModel.setPage(viewModel.page - 1),
                  onNext: () => viewModel.setPage(viewModel.page + 1),
                  hasPrev: viewModel.hasPrev,
                  hasNext: viewModel.hasNext,
                  pageSizeLabelBuilder: (size) =>
                      _pageSizeLabel.replaceFirst('{size}', size.toString()),
                )
              : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    List<QualityInspection> inspections,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    Widget listContent;
    if (viewModel.loading && inspections.isEmpty) {
      listContent = const Center(child: CircularProgressIndicator());
    } else if (viewModel.errorMessage != null && !viewModel.loading) {
      listContent = ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadInspections(resetPage: true),
      );
    } else if (!viewModel.loading && inspections.isEmpty) {
      listContent = const EmptyStateCard(
        icon: Icons.verified_outlined,
        text: _emptyText,
      );
    } else {
      if (!isMobile) {
        listContent = _buildDesktopTable(context, viewModel, inspections);
      } else {
        listContent = ListView.separated(
          itemCount: inspections.length,
          separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
          itemBuilder: (context, index) {
            final inspection = inspections[index];
            return _buildSummaryCard(context, viewModel, inspection, isMobile);
          },
        );
      }
    }

    return listContent;
  }

  Widget _buildDesktopTable(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    List<QualityInspection> inspections,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('质检单号')),
        DataColumn(label: Text('施工单号')),
        DataColumn(label: Text('产品')),
        DataColumn(label: Text('检验员')),
        DataColumn(label: Text('检验日期')),
        DataColumn(label: Text('结果')),
        DataColumn(label: Text('不良率')),
        DataColumn(label: Text('操作')),
      ],
      rows: inspections.map(
        (inspection) {
          final canComplete = (inspection.result ?? 'pending') == 'pending';
          return DataRow(
            cells: [
              DataCell(Text(
                _displayText(inspection.inspectionNumber),
                style: theme.textTheme.bodyMedium,
              )),
              DataCell(Text(_displayText(inspection.workOrderNumber),
                  style: textStyle)),
              DataCell(
                  Text(_displayText(inspection.productName), style: textStyle)),
              DataCell(Text(_displayText(inspection.inspectorName),
                  style: textStyle)),
              DataCell(Text(_formatDate(inspection.inspectionDate),
                  style: textStyle)),
              DataCell(Text(
                inspection.resultDisplay ?? inspection.result ?? _emptyCellText,
                style: textStyle,
              )),
              DataCell(Text(inspection.defectiveRateFormatted ?? _emptyCellText,
                  style: textStyle)),
              DataCell(RowActionGroup(
                actions: [
                  RowAction(
                    label: _hasAttachment(inspection) ? '更新附件' : '上传附件',
                    icon: Icons.upload_file_outlined,
                    onPressed: () => _uploadAttachment(viewModel, inspection),
                  ),
                  RowAction(
                    label: '查看',
                    onPressed: () => _openDetailDialog(inspection),
                  ),
                  if (_hasAttachment(inspection))
                    RowAction(
                      label: '附件',
                      icon: Icons.attach_file_outlined,
                      onPressed: () => _openAttachment(inspection),
                    ),
                  if (canComplete)
                    RowAction(
                      label: _completeTitle,
                      onPressed: () =>
                          _openCompleteDialog(context, viewModel, inspection),
                    ),
                ],
              )),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    bool isMobile,
  ) {
    void openFilterDrawer() {
      if (isMobile) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          builder: (sheetContext) {
            return _FilterDrawerContent(
              title: '筛选',
              child: _buildFilterPanel(
                sheetContext,
                viewModel,
                bottomSpacing: 16,
              ),
            );
          },
        );
        return;
      }

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '筛选',
        barrierColor: Colors.black.withValues(alpha: 0.3),
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (dialogContext, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Theme.of(dialogContext).colorScheme.surface,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: SizedBox(
                width: 360,
                height: double.infinity,
                child: SafeArea(
                  child: _FilterDrawerContent(
                    title: '筛选',
                    child: _buildFilterPanel(
                      dialogContext,
                      viewModel,
                      bottomSpacing: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final offsetTween =
              Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
          return SlideTransition(
            position: animation
                .drive(
                  CurveTween(curve: Curves.easeOutCubic),
                )
                .drive(offsetTween),
            child: child,
          );
        },
      );
    }

    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final activeFilters = _activeFilterCount(viewModel);
          final pendingExceptions = viewModel.inspections
              .where((item) => _needsExceptionFollowUp(item))
              .length;
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: _controlHeight,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          final actions = <Widget>[
            if (pendingExceptions > 0)
              StatusHintChip(label: '待跟进异常', count: pendingExceptions),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadInspections(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: activeFilters > 0 ? '筛选 $activeFilters' : '筛选',
            ),
          ];

          return ListToolbar(
            isMobile: isMobile,
            searchField: searchField,
            actions: actions,
            spacing: _spacingSm,
          );
        },
      ),
    );
  }

  Widget _buildFilterPanel(
    BuildContext context,
    QualityInspectionViewModel viewModel, {
    required double bottomSpacing,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    final resultValue =
        viewModel.resultFilter.isEmpty ? '' : viewModel.resultFilter;
    final typeValue = viewModel.typeFilter.isEmpty ? '' : viewModel.typeFilter;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchableDropdownFormField<String>(
          key: ValueKey<String>(typeValue),
          initialValue: typeValue,
          isExpanded: true,
          decoration: const InputDecoration(labelText: _typeFilterLabel),
          items: const [
            DropdownMenuItem(value: '', child: Text('全部类型')),
            DropdownMenuItem(value: 'incoming', child: Text('来料检验')),
            DropdownMenuItem(value: 'process', child: Text('过程检验')),
            DropdownMenuItem(value: 'final', child: Text('成品检验')),
            DropdownMenuItem(value: 'customer', child: Text('客诉检验')),
          ],
          onChanged: (value) => viewModel.setTypeFilter(value ?? ''),
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<String>(
          key: ValueKey<String>(resultValue),
          initialValue: resultValue,
          isExpanded: true,
          decoration: const InputDecoration(labelText: _resultFilterLabel),
          items: const [
            DropdownMenuItem(value: '', child: Text('全部结果')),
            DropdownMenuItem(value: 'pending', child: Text('待检验')),
            DropdownMenuItem(value: 'passed', child: Text('合格')),
            DropdownMenuItem(value: 'failed', child: Text('不合格')),
            DropdownMenuItem(value: 'conditional', child: Text('条件接收')),
          ],
          onChanged: (value) => viewModel.setResultFilter(value ?? ''),
        ),
        SizedBox(height: bottomSpacing < spacing ? spacing : bottomSpacing),
        Row(
          children: [
            PageActionButton.outlined(
              onPressed: () => _resetFilters(viewModel),
              icon: const Icon(Icons.restart_alt, size: 16),
              label: _resetButtonText,
            ),
            SizedBox(width: spacing),
            PageActionButton.filled(
              onPressed: () => Navigator.of(context).maybePop(),
              label: '完成',
            ),
          ],
        ),
      ],
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [content],
    );
  }

  int _activeFilterCount(QualityInspectionViewModel viewModel) {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (viewModel.typeFilter.isNotEmpty) count += 1;
    if (viewModel.resultFilter.isNotEmpty) count += 1;
    return count;
  }

  void _resetFilters(QualityInspectionViewModel viewModel) {
    _searchController.clear();
    viewModel.setSearchText('');
    var needsReload = false;
    if (viewModel.typeFilter.isNotEmpty) {
      needsReload = true;
      viewModel.setTypeFilter('');
    }
    if (viewModel.resultFilter.isNotEmpty) {
      needsReload = true;
      viewModel.setResultFilter('');
    }
    if (!needsReload) {
      viewModel.loadInspections(resetPage: true);
    }
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  Widget _buildSummaryCard(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    QualityInspection inspection,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number = inspection.inspectionNumber.isEmpty
        ? '质检 #${inspection.id}'
        : inspection.inspectionNumber;
    final workOrder = _displayText(inspection.workOrderNumber);
    final product = _displayText(inspection.productName);
    final inspector = _displayText(inspection.inspectorName);
    final result =
        inspection.resultDisplay ?? inspection.result ?? _emptyCellText;
    final defectiveRate = inspection.defectiveRateFormatted ?? _emptyCellText;
    final inspectionDate = _formatDate(inspection.inspectionDate);
    final attachmentStatus =
        _hasAttachment(inspection) ? '已上传' : _emptyCellText;
    final canComplete = (inspection.result ?? 'pending') == 'pending';
    final needsFollowUp = _needsExceptionFollowUp(inspection);

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    number,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    '$workOrder · $product',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '结果', value: result),
                      _SummaryChip(label: '不良率', value: defectiveRate),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  inspectionDate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors?.subtleText ?? theme.hintColor,
                  ),
                ),
                SizedBox(height: sectionSpacing),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more,
                    size: 20,
                    color: colors?.subtleText ?? theme.hintColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(
            isMobile: isMobile,
            children: [
              _SummaryField(label: '质检单号', value: number),
              _SummaryField(label: '施工单号', value: workOrder),
              _SummaryField(label: '产品', value: product),
              _SummaryField(label: '检验员', value: inspector),
              _SummaryField(label: '检验日期', value: inspectionDate),
              _SummaryField(label: '结果', value: result),
              _SummaryField(label: '不良率', value: defectiveRate),
              _SummaryField(label: '附件', value: attachmentStatus),
              if (needsFollowUp)
                _SummaryField(
                    label: '异常跟进', value: _qualityNextStep(inspection)),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _uploadAttachment(viewModel, inspection),
                icon: const Icon(Icons.upload_file_outlined, size: 16),
                label: Text(_hasAttachment(inspection) ? '更新附件' : '上传附件'),
              ),
              OutlinedButton.icon(
                onPressed: () => _openDetailDialog(inspection),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('查看'),
              ),
              if (_hasAttachment(inspection))
                AttachmentOpenButton(
                  fileUrl: inspection.attachmentUrl,
                  label: '查看附件',
                  errorPrefix: '打开检验附件失败',
                ),
              if (canComplete)
                OutlinedButton.icon(
                  onPressed: () =>
                      _openCompleteDialog(context, viewModel, inspection),
                  icon: const Icon(Icons.verified_outlined, size: 16),
                  label: const Text(_completeTitle),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _hasAttachment(QualityInspection inspection) {
    return FileLinkUtil.hasLink(inspection.attachmentUrl);
  }

  bool _needsExceptionFollowUp(QualityInspection inspection) {
    final result = inspection.result ?? '';
    return result == 'failed' || result == 'conditional';
  }

  String _qualityIssueSummary(QualityInspection inspection) {
    final defectDescription = (inspection.defectDescription ?? '').trim();
    if (defectDescription.isNotEmpty) {
      return defectDescription;
    }
    if (inspection.defects.isNotEmpty) {
      return inspection.defects.join('、');
    }
    return inspection.resultDisplay ?? inspection.result ?? '存在待处理质检异常';
  }

  String? _qualityDispositionComment(QualityInspection inspection) {
    final disposition = (inspection.disposition ?? '').trim();
    final notes = (inspection.dispositionNotes ?? '').trim();
    if (disposition.isEmpty && notes.isEmpty) {
      return null;
    }
    if (disposition.isEmpty) {
      return notes;
    }
    if (notes.isEmpty) {
      return disposition;
    }
    return '$disposition\n$notes';
  }

  String _qualityNextStep(QualityInspection inspection) {
    if ((inspection.result ?? '') == 'conditional') {
      return '请按处理意见落实条件接收范围，并补充检验附件留痕。';
    }
    return '请根据处理意见安排返工、复检或判退，并同步更新施工单执行。';
  }

  Future<void> _openAttachment(QualityInspection inspection) async {
    try {
      await FileLinkUtil.open(inspection.attachmentUrl);
    } catch (err) {
      ToastUtil.showError('打开检验附件失败: $err');
    }
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDrawerContent extends StatelessWidget {
  const _FilterDrawerContent({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}
