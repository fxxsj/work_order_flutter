import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/approval_rejection_notice_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/file_upload_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/attachment_open_button.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
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
        context.read<QualityInspectionRepository>(),
        context.read<QualityInspectionApiService>(),
      ),
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
  static const _searchDebounceDuration = AnimationTokens.slower;
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索检验单号/施工单号/客户';
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
  String? _routeSignature;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = GoRouterState.of(context).uri;
    final search = uri.queryParameters['search']?.trim() ?? '';
    final result = uri.queryParameters['result']?.trim() ?? '';
    final inspectionType = uri.queryParameters['type']?.trim() ?? '';
    final todo = uri.queryParameters['todo']?.trim() ?? '';
    final departmentId =
        int.tryParse(uri.queryParameters['department_id'] ?? '');
    final signature = [
      search,
      result,
      inspectionType,
      todo,
      departmentId?.toString() ?? '',
    ].join('|');
    if (_routeSignature == signature) return;
    _routeSignature = signature;

    _searchController.text = search;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<QualityInspectionViewModel>().applyRoutePrefill(
            search: search,
            result: result,
            inspectionType: inspectionType,
            departmentId: departmentId,
            todo: todo,
          );
    });
  }

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
    await showAdaptiveFilterDrawer(
      context,
      isMobile: BreakpointsUtil.isMobile(context),
      title: _detailTitle,
      desktopWidth: LayoutTokens.dialogWidthLg,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(LayoutTokens.gapLg),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inspection.inspectionNumber,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapXxs),
                      Text(
                        '在当前列表上下文中查看质检细节，并直接处理异常、附件和施工单跳转。',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      Wrap(
                        spacing: LayoutTokens.gapMd,
                        runSpacing: LayoutTokens.gapSm,
                        children: [
                          _buildDetailSummaryItem(
                            context,
                            '客户',
                            _displayText(inspection.customerName),
                          ),
                          _buildDetailSummaryItem(
                            context,
                            '结果',
                            _displayText(
                              inspection.resultDisplay ?? inspection.result,
                            ),
                          ),
                          _buildDetailSummaryItem(
                            context,
                            '下一步',
                            _qualityFollowUpText(inspection),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LayoutTokens.gapLg),
                if (_needsExceptionFollowUp(inspection) ||
                    _hasRecordedExceptionAction(inspection)) ...[
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
                    primaryAction: FilledButton.icon(
                      onPressed: () => _openExceptionFollowUpDialog(
                        context,
                        context.read<QualityInspectionViewModel>(),
                        inspection,
                      ),
                      icon: const Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 18,
                      ),
                      label: Text(
                        _hasRecordedExceptionAction(inspection)
                            ? '更新处理'
                            : '处理异常',
                      ),
                    ),
                    secondaryAction: inspection.workOrderId == null
                        ? null
                        : OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).maybePop();
                              context
                                  .go('/workorders/${inspection.workOrderId}');
                            },
                            icon: const Icon(Icons.open_in_new, size: 18),
                            label: const Text('查看施工单'),
                          ),
                  ),
                  const SizedBox(height: LayoutTokens.gapLg),
                ],
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '基础信息',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      _DetailRow(
                        label: '客户',
                        value: _displayText(inspection.customerName),
                      ),
                      _DetailRow(
                          label: '质检单号', value: inspection.inspectionNumber),
                      _DetailRow(
                        label: '检验类型',
                        value: _displayText(
                          inspection.inspectionTypeDisplay ??
                              inspection.inspectionType,
                        ),
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
                    ],
                  ),
                ),
                const SizedBox(height: LayoutTokens.gapLg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '结果与处置',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
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
                          inspection.resultDisplay ?? inspection.result,
                        ),
                      ),
                      _DetailRow(
                        label: '下一步',
                        value: _qualityFollowUpText(inspection),
                      ),
                      _DetailRow(
                        label: '检验附件',
                        value:
                            _hasAttachment(inspection) ? '已上传' : _emptyCellText,
                      ),
                      if ((inspection.inspectionStandard ?? '')
                          .trim()
                          .isNotEmpty)
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
                      if ((inspection.defectDescription ?? '')
                          .trim()
                          .isNotEmpty)
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LayoutTokens.gapLg,
              LayoutTokens.gapMd,
              LayoutTokens.gapLg,
              LayoutTokens.gapLg,
            ),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => _uploadAttachment(
                    context.read<QualityInspectionViewModel>(),
                    inspection,
                  ),
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: Text(_hasAttachment(inspection) ? '更新附件' : '上传附件'),
                ),
                const SizedBox(width: LayoutTokens.gapSm),
                if (_hasAttachment(inspection))
                  AttachmentOpenButton(
                    fileUrl: inspection.attachmentUrl,
                    label: '查看附件',
                    errorPrefix: '打开检验附件失败',
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text(_cancelText),
                ),
              ],
            ),
          ),
        ],
      ),
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
            return AppFormDialog(
              title: _completeTitle,
              formKey: formKey,
              submitting: submitting,
              submitText: _submitText,
              cancelText: _cancelText,
              maxWidth: LayoutTokens.dialogWidthSm,
              onCancel: () => Navigator.of(dialogContext).pop(),
              onSubmit: () => submit(setState),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSelect<String>(
                    key: ValueKey<String>(result),
                    value: result,
                    decoration: const InputDecoration(labelText: '检验结果'),
                    options: const [
                      AppDropdownOption(value: 'passed', label: '合格'),
                      AppDropdownOption(value: 'failed', label: '不合格'),
                      AppDropdownOption(value: 'conditional', label: '条件接收'),
                    ],
                    onChanged: submitting
                        ? null
                        : (value) {
                            if (value == null) return;
                            setState(() => result = value);
                          },
                  ),
                  const SizedBox(height: 12),
                  CrudFormField.number(
                    label: '合格数量',
                    controller: passedController,
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      final parsed = int.tryParse(text);
                      if (parsed == null || parsed < 0) {
                        return '请输入有效数量';
                      }
                      return null;
                    },
                  ).build(context),
                  const SizedBox(height: 12),
                  CrudFormField.number(
                    label: '不合格数量',
                    controller: failedController,
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      final parsed = int.tryParse(text);
                      if (parsed == null || parsed < 0) {
                        return '请输入有效数量';
                      }
                      return null;
                    },
                  ).build(context),
                ],
              ),
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
    final pickedFile = await showFileUploadDialog(
      context,
      title: '上传检验附件',
      label: '检验附件',
      allowedExtensions: _attachmentExtensions,
      fallbackFilename: 'quality-attachment',
      helperText: '支持质检报告、图片和 PDF',
      submitText: '上传',
    );
    final attachment = pickedFile?.file;
    if (attachment == null) {
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

  Future<void> _openExceptionFollowUpDialog(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    QualityInspection inspection,
  ) async {
    final decision = await showActionDecisionDialog<String>(
      context,
      title: _hasRecordedExceptionAction(inspection) ? '更新异常处理' : '登记异常处理',
      summary: '请记录当前质检异常的处理方案，处理结论会影响返工、报废、退货或放行后的后续流程。',
      impacts: [
        '质检单号：${_displayText(inspection.inspectionNumber)}',
        '产品：${_displayText(inspection.productName)}',
        '检验结果：${_displayText(inspection.resultDisplay ?? inspection.result)}',
        if (inspection.defects.isNotEmpty) '缺陷：${inspection.defects.join('、')}',
      ],
      auditHint: '请填写清晰的处理结论和说明，便于后续复检、责任追踪和审计复盘。',
      selectionLabel: '处理结论',
      options: const [
        ActionDecisionOption(value: 'accept', label: '接收放行'),
        ActionDecisionOption(value: 'rework', label: '安排返工'),
        ActionDecisionOption(value: 'scrap', label: '判定报废'),
        ActionDecisionOption(value: 'return', label: '退货处理'),
      ],
      initialSelection: (inspection.disposition ?? '').trim().isEmpty
          ? null
          : inspection.disposition!.trim(),
      requireSelection: true,
      selectionErrorText: '请选择处理结论',
      notesLabel: '处理说明',
      notesHint: '填写返工安排、责任人、复检要求或放行范围',
      initialNotes: inspection.dispositionNotes ?? '',
      requireNotes: true,
      notesErrorText: '请填写处理说明',
      submitText: '保存处理',
    );
    if (decision == null || decision.selection == null) {
      return;
    }
    try {
      await viewModel.updateInspection(inspection.id, {
        'disposition': decision.selection,
        'disposition_notes': decision.notes,
      });
      if (!mounted) return;
      ToastUtil.showSuccess('异常处理已登记');
      await viewModel.loadInspections(resetPage: false);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('登记异常处理失败: $err');
    }
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
        DataColumn(label: Text('来源')),
        DataColumn(label: Text('产品')),
        DataColumn(label: Text('检验员')),
        DataColumn(label: Text('检验日期')),
        DataColumn(label: Text('结果')),
        DataColumn(label: Text('数量')),
        DataColumn(label: Text('待办')),
        DataColumn(label: Text('操作')),
      ],
      rows: inspections.map(
        (inspection) {
          final canComplete = (inspection.result ?? 'pending') == 'pending';
          return DataRow(
            cells: [
              DataCell(
                InkWell(
                  onTap: () => _openDetailDialog(inspection),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      _displayText(inspection.inspectionNumber),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(
                  Text(_qualitySourceSummary(inspection), style: textStyle)),
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
              DataCell(
                  Text(_qualityQuantitySummary(inspection), style: textStyle)),
              DataCell(
                  Text(_qualityFollowUpText(inspection), style: textStyle)),
              DataCell(RowActionGroup(
                actions: [
                  if (_needsExceptionFollowUp(inspection) ||
                      _hasRecordedExceptionAction(inspection))
                    RowAction(
                      label: _hasRecordedExceptionAction(inspection)
                          ? '更新处理'
                          : '处理异常',
                      icon: Icons.assignment_turned_in_outlined,
                      onPressed: () => _openExceptionFollowUpDialog(
                        context,
                        viewModel,
                        inspection,
                      ),
                    ),
                  RowAction(
                    label: _hasAttachment(inspection) ? '更新附件' : '上传附件',
                    icon: Icons.upload_file_outlined,
                    onPressed: () => _uploadAttachment(viewModel, inspection),
                  ),
                  if ((inspection.workOrderNumber ?? '').trim().isNotEmpty &&
                      (inspection.result ?? '') != 'pending')
                    RowAction(
                      label: '查看入库',
                      icon: Icons.inventory_2_outlined,
                      onPressed: () =>
                          _openStockInList(inspection.workOrderNumber!),
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
      showAdaptiveFilterDrawer(
        context,
        isMobile: isMobile,
        child: _buildFilterPanel(
          context,
          viewModel,
          bottomSpacing: isMobile ? 16 : 20,
        ),
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
          final pendingCount =
              _summaryCount(viewModel.summary, 'pending_count');
          final pendingExceptions =
              _summaryCount(viewModel.summary, 'unresolved_exception_count');
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
            if (pendingCount > 0)
              StatusHintChip(
                label: '待完成检验',
                count: pendingCount,
                icon: Icons.fact_check_outlined,
                selected: viewModel.resultFilter == 'pending' &&
                    viewModel.todoFilter.isEmpty,
                onTap: () => _openQuickFilter(viewModel, result: 'pending'),
              ),
            if (pendingExceptions > 0)
              StatusHintChip(
                label: '待跟进异常',
                count: pendingExceptions,
                selected: viewModel.todoFilter == 'exception_followup',
                onTap: () =>
                    _openQuickFilter(viewModel, todo: 'exception_followup'),
              ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadInspections(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            if (viewModel.todoFilter.isNotEmpty)
              PageActionButton.outlined(
                onPressed: () => _clearQuickFilter(viewModel),
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: '清除待办',
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
    final resultValue =
        viewModel.resultFilter.isEmpty ? '' : viewModel.resultFilter;
    final typeValue = viewModel.typeFilter.isEmpty ? '' : viewModel.typeFilter;
    return FilterPanelBody(
      bottomSpacing: bottomSpacing,
      resetLabel: _resetButtonText,
      onReset: () => _resetFilters(viewModel),
      fields: [
        AppSelect<String>(
          key: ValueKey<String>(typeValue),
          value: typeValue.isEmpty ? null : typeValue,
          decoration: const InputDecoration(labelText: _typeFilterLabel),
          options: const [
            AppDropdownOption<String>(value: '', label: '全部类型'),
            AppDropdownOption<String>(value: 'incoming', label: '来料检验'),
            AppDropdownOption<String>(value: 'process', label: '过程检验'),
            AppDropdownOption<String>(value: 'final', label: '成品检验'),
            AppDropdownOption<String>(value: 'customer', label: '客诉检验'),
          ],
          onChanged: (value) => viewModel.setTypeFilter(value ?? ''),
        ),
        AppSelect<String>(
          key: ValueKey<String>(resultValue),
          value: resultValue.isEmpty ? null : resultValue,
          decoration: const InputDecoration(labelText: _resultFilterLabel),
          options: const [
            AppDropdownOption<String>(value: '', label: '全部结果'),
            AppDropdownOption<String>(value: 'pending', label: '待检验'),
            AppDropdownOption<String>(value: 'passed', label: '合格'),
            AppDropdownOption<String>(value: 'failed', label: '不合格'),
            AppDropdownOption<String>(value: 'conditional', label: '条件接收'),
          ],
          onChanged: (value) => viewModel.setResultFilter(value ?? ''),
        ),
      ],
    );
  }

  int _activeFilterCount(QualityInspectionViewModel viewModel) {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (viewModel.typeFilter.isNotEmpty) count += 1;
    if (viewModel.resultFilter.isNotEmpty) count += 1;
    if (viewModel.todoFilter.isNotEmpty) count += 1;
    if (viewModel.departmentId > 0) count += 1;
    return count;
  }

  void _resetFilters(QualityInspectionViewModel viewModel) {
    _searchController.clear();
    context.go('/quality-inspections');
  }

  void _clearQuickFilter(QualityInspectionViewModel viewModel) {
    _openQuickFilter(
      viewModel,
      result: viewModel.resultFilter,
      inspectionType: viewModel.typeFilter,
      departmentId: viewModel.departmentId > 0 ? viewModel.departmentId : null,
    );
  }

  void _openQuickFilter(
    QualityInspectionViewModel viewModel, {
    String? result,
    String? inspectionType,
    int? departmentId,
    String? todo,
  }) {
    final query = <String, String>{};
    final search = _searchController.text.trim();
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    if ((result ?? '').trim().isNotEmpty) {
      query['result'] = result!.trim();
    }
    if ((inspectionType ?? '').trim().isNotEmpty) {
      query['type'] = inspectionType!.trim();
    }
    if ((todo ?? '').trim().isNotEmpty) {
      query['todo'] = todo!.trim();
    }
    if ((departmentId ?? 0) > 0) {
      query['department_id'] = departmentId!.toString();
    }
    context.go(
        Uri(path: '/quality-inspections', queryParameters: query).toString());
  }

  int _summaryCount(Map<String, dynamic> payload, String key) {
    final summary = payload['summary'];
    if (summary is Map<String, dynamic>) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    if (summary is Map) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    return 0;
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
    final customer = _displayText(inspection.customerName);
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
    final followUp = _qualityFollowUpText(inspection);

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _openDetailDialog(inspection),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        number,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    _qualitySourceSummary(inspection),
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
                      _SummaryChip(label: '待办', value: followUp),
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
                  duration: AnimationTokens.expandDuration,
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
          _buildMobileFields(
            context,
            inspection: inspection,
            number: number,
            customer: customer,
            workOrder: workOrder,
            product: product,
            inspector: inspector,
            inspectionDate: inspectionDate,
            result: result,
            defectiveRate: defectiveRate,
            attachmentStatus: attachmentStatus,
            followUp: followUp,
            needsFollowUp: needsFollowUp,
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_needsExceptionFollowUp(inspection) ||
                  _hasRecordedExceptionAction(inspection))
                OutlinedButton.icon(
                  onPressed: () => _openExceptionFollowUpDialog(
                      context, viewModel, inspection),
                  icon:
                      const Icon(Icons.assignment_turned_in_outlined, size: 16),
                  label: Text(
                    _hasRecordedExceptionAction(inspection) ? '更新处理' : '处理异常',
                  ),
                ),
              OutlinedButton.icon(
                onPressed: () => _uploadAttachment(viewModel, inspection),
                icon: const Icon(Icons.upload_file_outlined, size: 16),
                label: Text(_hasAttachment(inspection) ? '更新附件' : '上传附件'),
              ),
              if ((inspection.workOrderNumber ?? '').trim().isNotEmpty &&
                  (inspection.result ?? '') != 'pending')
                OutlinedButton.icon(
                  onPressed: () =>
                      _openStockInList(inspection.workOrderNumber!),
                  icon: const Icon(Icons.inventory_2_outlined, size: 16),
                  label: const Text('查看入库'),
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
    return (result == 'failed' || result == 'conditional') &&
        !_hasRecordedExceptionAction(inspection);
  }

  bool _hasRecordedExceptionAction(QualityInspection inspection) {
    return (inspection.disposition ?? '').trim().isNotEmpty ||
        (inspection.dispositionNotes ?? '').trim().isNotEmpty;
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
    final disposition = _qualityDispositionLabel(inspection);
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

  String _qualityDispositionLabel(QualityInspection inspection) {
    switch ((inspection.disposition ?? '').trim()) {
      case 'accept':
        return '接收放行';
      case 'rework':
        return '安排返工';
      case 'scrap':
        return '判定报废';
      case 'return':
        return '退货处理';
      default:
        return (inspection.disposition ?? '').trim();
    }
  }

  String _qualityNextStep(QualityInspection inspection) {
    if (_hasRecordedExceptionAction(inspection)) {
      return '已登记处理意见，按说明执行并在完成后补充附件或复检结果。';
    }
    if ((inspection.result ?? '') == 'conditional') {
      return '请按处理意见落实条件接收范围，并补充检验附件留痕。';
    }
    return '请根据处理意见安排返工、复检或判退，并同步更新施工单执行。';
  }

  String _qualitySourceSummary(QualityInspection inspection) {
    final customer = (inspection.customerName ?? '').trim();
    final workOrder = (inspection.workOrderNumber ?? '').trim();
    if (customer.isNotEmpty && workOrder.isNotEmpty) {
      return '$customer · $workOrder';
    }
    if (customer.isNotEmpty) return customer;
    if (workOrder.isNotEmpty) return workOrder;
    return _emptyCellText;
  }

  String _qualityQuantitySummary(QualityInspection inspection) {
    final passed = _formatAmount(inspection.passedQuantity);
    final failed = _formatAmount(inspection.failedQuantity);
    return '合格 $passed / 不合格 $failed';
  }

  String _qualityFollowUpText(QualityInspection inspection) {
    switch (inspection.result ?? 'pending') {
      case 'pending':
        return '待完成检验';
      case 'passed':
        return '可安排入库/发货准备';
      case 'conditional':
        return _hasRecordedExceptionAction(inspection)
            ? '已登记条件接收处理'
            : '按处理意见继续跟进';
      case 'failed':
        return _hasRecordedExceptionAction(inspection)
            ? '已登记返工/判退处理'
            : '待返工/复检';
      default:
        return _emptyCellText;
    }
  }

  void _openStockInList(String workOrderNumber) {
    final uri = Uri(
      path: '/stock-ins',
      queryParameters: {'search': workOrderNumber},
    );
    context.go(uri.toString());
  }

  Future<void> _openAttachment(QualityInspection inspection) async {
    try {
      await FileLinkUtil.open(inspection.attachmentUrl);
    } catch (err) {
      ToastUtil.showError('打开检验附件失败: $err');
    }
  }

  Widget _mobileRow(
    BuildContext context,
    TextStyle? labelStyle,
    String label,
    String value, {
    bool last = false,
  }) {
    final theme = Theme.of(context);
    final spacing = LayoutTokens.sectionSpacing(context) * 0.6;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: labelStyle),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? _emptyCellText : value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFields(
    BuildContext context, {
    required QualityInspection inspection,
    required String number,
    required String customer,
    required String workOrder,
    required String product,
    required String inspector,
    required String inspectionDate,
    required String result,
    required String defectiveRate,
    required String attachmentStatus,
    required String followUp,
    required bool needsFollowUp,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: colors?.subtleText ?? theme.hintColor,
    );
    final rows = <Widget>[
      _mobileRow(context, labelStyle, '质检单号', number),
      _mobileRow(context, labelStyle, '客户', customer),
      _mobileRow(context, labelStyle, '施工单号', workOrder),
      _mobileRow(context, labelStyle, '产品', product),
      _mobileRow(context, labelStyle, '检验员', inspector),
      _mobileRow(context, labelStyle, '检验日期', inspectionDate),
      _mobileRow(context, labelStyle, '结果', result),
      _mobileRow(context, labelStyle, '不良率', defectiveRate),
      _mobileRow(
          context, labelStyle, '数量', _qualityQuantitySummary(inspection)),
      _mobileRow(context, labelStyle, '附件', attachmentStatus),
      _mobileRow(context, labelStyle, '下一步', followUp),
    ];
    if (_hasRecordedExceptionAction(inspection)) {
      rows.add(_mobileRow(
        context,
        labelStyle,
        '处理结论',
        _displayText(_qualityDispositionLabel(inspection)),
      ));
    }
    if (needsFollowUp) {
      rows.add(_mobileRow(
        context,
        labelStyle,
        '异常跟进',
        _qualityNextStep(inspection),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}

typedef _SummaryChip = SummaryChip;

Widget _buildDetailSummaryItem(
  BuildContext context,
  String label,
  String value,
) {
  final theme = Theme.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: theme.textTheme.bodySmall),
      const SizedBox(height: LayoutTokens.gapXxxs),
      Text(
        value,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

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
