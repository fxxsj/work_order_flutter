import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page_types.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/page_registry.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';

const String _emptyText = '-';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key, required this.selectedId});

  final String selectedId;

  @override
  Widget build(BuildContext context) {
    final fullPage = buildFullPage(selectedId);
    if (fullPage != null) {
      return fullPage;
    }
    if (selectedId == 'dashboard') {
      return const _DashboardPage();
    }

    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final style = ContentAreaStyle(
      primary: theme.colorScheme.primary,
      surface: colors.surface,
      accent: colors.sidebarText,
      subtleText: colors.subtleText,
      borderColor: colors.borderColor,
    );

    return _ContentArea(
      selectedId: selectedId,
      style: style,
      bodyBuilder: buildContentBody(selectedId),
    );
  }
}

class _DashboardPage extends StatefulWidget {
  const _DashboardPage();

  @override
  State<_DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<_DashboardPage> {
  ApiClient? _apiClient;
  bool _loadingStats = false;
  bool _initialized = false;
  Map<String, dynamic>? _stats;
  String? _errorMessage;

  static const List<String> _quickIds = [
    'workorders',
    'tasks_list',
    'sales_orders',
    'delivery',
    'quality',
    'notifications',
  ];

  static const List<String> _spotlightIds = [
    'products',
    'customers',
    'purchase_orders',
    'statements',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _apiClient ??= context.read<ApiClient>();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final apiClient = _apiClient;
    if (apiClient == null) return;
    setState(() {
      _loadingStats = true;
      _errorMessage = null;
    });
    try {
      final service = WorkOrderApiService(apiClient);
      final result = await service.getStatistics();
      if (!mounted) return;
      setState(() => _stats = result);
    } catch (err) {
      if (!mounted) return;
      setState(() => _errorMessage = '获取统计失败: $err');
    } finally {
      if (mounted) setState(() => _loadingStats = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.extension<AppColors>()!;
    final currentUser = _readCurrentUser(context);
    final leaves = leafNavItemsByBranch(currentUser: currentUser);
    final quickEntries = _quickIds
        .map((id) => leaves.where((item) => item.id == id).firstOrNull)
        .whereType<NavItem>()
        .toList();
    final spotlightEntries = _spotlightIds
        .map((id) => leaves.where((item) => item.id == id).firstOrNull)
        .whereType<NavItem>()
        .toList();
    final groups = sidebarNavItems(currentUser: currentUser)
        .where((item) => item.children.isNotEmpty)
        .take(4)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        final narrow = constraints.maxWidth < 640;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            narrow ? LayoutTokens.gapLg : LayoutTokens.gapXl,
            narrow
                ? LayoutTokens.gapLg
                : LayoutTokens.gapLg + LayoutTokens.gapXs,
            narrow ? LayoutTokens.gapLg : LayoutTokens.gapXl,
            LayoutTokens.gapXl + LayoutTokens.gapSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardHero(
                title: '工作台',
                subtitle: _todayLabel(),
                primary: scheme.primary,
                accent: colors.sidebarText,
                borderColor: colors.borderColor,
                surface: colors.surface,
              ),
              SizedBox(height: LayoutTokens.gapMd),
              _DashboardStatsSection(
                stats: _stats,
                loading: _loadingStats,
                errorMessage: _errorMessage,
                onRetry: _loadStats,
                surface: colors.surface,
                borderColor: colors.borderColor,
                subtleText: colors.subtleText,
                accent: colors.sidebarText,
                primary: scheme.primary,
              ),
              SizedBox(height: LayoutTokens.gapLg),
              _DashboardChartsSection(
                stats: _stats,
                surface: colors.surface,
                borderColor: colors.borderColor,
                subtleText: colors.subtleText,
                accent: colors.sidebarText,
                primary: scheme.primary,
              ),
              SizedBox(height: LayoutTokens.gapLg),
              if (compact) ...[
                _QuickEntrySection(
                  entries: quickEntries,
                  surface: colors.surface,
                  borderColor: colors.borderColor,
                  accent: colors.sidebarText,
                  subtleText: colors.subtleText,
                  primary: scheme.primary,
                ),
                SizedBox(height: LayoutTokens.gapLg),
                _SimpleModuleSection(
                  entries: spotlightEntries,
                  surface: colors.surface,
                  borderColor: colors.borderColor,
                  accent: colors.sidebarText,
                  subtleText: colors.subtleText,
                  primary: scheme.primary,
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 13,
                      child: _QuickEntrySection(
                        entries: quickEntries,
                        surface: colors.surface,
                        borderColor: colors.borderColor,
                        accent: colors.sidebarText,
                        subtleText: colors.subtleText,
                        primary: scheme.primary,
                      ),
                    ),
                    SizedBox(width: LayoutTokens.gapLg),
                    Expanded(
                      flex: 7,
                      child: _SimpleModuleSection(
                        entries: spotlightEntries,
                        surface: colors.surface,
                        borderColor: colors.borderColor,
                        accent: colors.sidebarText,
                        subtleText: colors.subtleText,
                        primary: scheme.primary,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: LayoutTokens.gapLg),
              _GroupPanel(
                groups: groups,
                surface: colors.surface,
                borderColor: colors.borderColor,
                accent: colors.sidebarText,
                subtleText: colors.subtleText,
                primary: scheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return '${now.month} 月 ${now.day} 日 ${weekdays[now.weekday - 1]}';
  }

  Map<String, dynamic>? _readCurrentUser(BuildContext context) {
    final raw = context.read<AppStorage>().read(Constant.KEY_CURRENT_USER_INFO);
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }
}

class _DashboardStatsSection extends StatelessWidget {
  const _DashboardStatsSection({
    required this.stats,
    required this.loading,
    required this.errorMessage,
    required this.onRetry,
    required this.surface,
    required this.borderColor,
    required this.subtleText,
    required this.accent,
    required this.primary,
  });

  final Map<String, dynamic>? stats;
  final bool loading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final Color surface;
  final Color borderColor;
  final Color subtleText;
  final Color accent;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    if (loading && stats == null) {
      return const LinearProgressIndicator(minHeight: 2);
    }
    if (errorMessage != null && stats == null) {
      return _DashboardErrorCard(message: errorMessage!, onRetry: onRetry);
    }
    if (stats == null) {
      return const SizedBox.shrink();
    }

    final metrics = _buildMetrics(stats!);
    if (metrics.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width < 640
            ? 1
            : width < 980
                ? 2
                : width < 1280
                    ? 3
                    : 4;
        final spacing = LayoutTokens.gapMd;
        final cardWidth =
            (width - spacing * (columns - 1)) / columns.clamp(1, 6);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: metrics
              .map(
                (metric) => SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    title: metric.title,
                    value: metric.value,
                    subtitle: metric.subtitle,
                    surface: surface,
                    borderColor: borderColor,
                    subtleText: subtleText,
                    accent: accent,
                    primary: primary,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  List<_StatMetric> _buildMetrics(Map<String, dynamic> stats) {
    final totalCount = _asInt(stats['total_count']);
    final upcoming = _asInt(stats['upcoming_deadline_count']);
    final pendingApproval = _asInt(stats['pending_approval_count']);
    final inProgress = _statusCount(stats, 'in_progress');
    final taskTotal =
        _asInt(_readNested(stats, ['task_statistics', 'total_count']));
    final taskCompletion =
        _asDouble(_readNested(stats, ['task_statistics', 'completion_rate']));
    final processCompletion = _asDouble(
        _readNested(stats, ['efficiency_analysis', 'process_completion_rate']));
    final defectiveRate = _asDouble(
        _readNested(stats, ['efficiency_analysis', 'defective_rate']));

    return [
      _StatMetric(title: '施工单总数', value: _formatInt(totalCount)),
      _StatMetric(title: '进行中施工单', value: _formatInt(inProgress)),
      _StatMetric(title: '待审核施工单', value: _formatInt(pendingApproval)),
      _StatMetric(title: '临期施工单', value: _formatInt(upcoming)),
      _StatMetric(
        title: '任务完成率',
        value: _formatPercent(taskCompletion),
        subtitle: taskTotal > 0 ? '任务总数 $taskTotal' : null,
      ),
      _StatMetric(
        title: '工序完成率',
        value: _formatPercent(processCompletion),
      ),
      _StatMetric(
        title: '不良品率',
        value: _formatPercent(defectiveRate),
      ),
    ];
  }

  int _statusCount(Map<String, dynamic> stats, String status) {
    final list = stats['status_statistics'];
    if (list is List) {
      for (final item in list) {
        if (item is Map && item['status'] == status) {
          return _asInt(item['count']);
        }
      }
    }
    return 0;
  }

  Object? _readNested(Map<String, dynamic> source, List<String> keys) {
    Object? current = source;
    for (final key in keys) {
      if (current is Map<String, dynamic>) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }

  int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double? _asDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  String _formatInt(int value) => value.toString();

  String _formatPercent(double? value) {
    if (value == null) return '-';
    return '${value.toStringAsFixed(1)}%';
  }
}

class _DashboardChartsSection extends StatelessWidget {
  const _DashboardChartsSection({
    required this.stats,
    required this.surface,
    required this.borderColor,
    required this.subtleText,
    required this.accent,
    required this.primary,
  });

  final Map<String, dynamic>? stats;
  final Color surface;
  final Color borderColor;
  final Color subtleText;
  final Color accent;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final data = stats;
    if (data == null) {
      return const SizedBox.shrink();
    }

    final cards = <_ChartCardData>[
      _ChartCardData(
        title: '施工单状态分布',
        items:
            _buildStatusItems(data['status_statistics'], _workOrderStatusLabel),
      ),
      _ChartCardData(
        title: '优先级分布',
        items: _buildStatusItems(data['priority_statistics'], _priorityLabel,
            keyName: 'priority'),
      ),
      _ChartCardData(
        title: '任务状态分布',
        items: _buildStatusItems(
          _readNested(data, ['task_statistics', 'status_statistics']),
          _taskStatusLabel,
        ),
      ),
      _ChartCardData(
        title: '客户 TOP',
        items: _buildTopItems(
          _readNested(data, ['business_analysis', 'customer_statistics']),
          labelKey: 'customer',
          valueKey: 'total',
          subtitleKey: 'completion_rate',
          subtitleSuffix: '% 完成率',
        ),
      ),
      _ChartCardData(
        title: '产品 TOP',
        items: _buildTopItems(
          _readNested(data, ['business_analysis', 'product_statistics']),
          labelKey: 'product_name',
          valueKey: 'order_count',
          subtitleKey: 'total_quantity',
          subtitleSuffix: ' 订单量',
          valueSuffix: '',
        ),
      ),
      _ChartCardData(
        title: '效率指标',
        items: _buildEfficiencyItems(data),
        totalOverride: 100,
        showPercent: false,
      ),
    ];

    final availableCards =
        cards.where((card) => card.items.isNotEmpty).toList();
    if (availableCards.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width < 700
            ? 1
            : width < 1080
                ? 2
                : 3;
        final spacing = LayoutTokens.gapMd;
        final cardWidth =
            (width - spacing * (columns - 1)) / columns.clamp(1, 6);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: availableCards
              .map(
                (card) => SizedBox(
                  width: cardWidth,
                  child: _ChartCard(
                    title: card.title,
                    items: card.items,
                    surface: surface,
                    borderColor: borderColor,
                    subtleText: subtleText,
                    accent: accent,
                    primary: primary,
                    totalOverride: card.totalOverride,
                    showPercent: card.showPercent,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  List<_ChartBarItem> _buildStatusItems(
    dynamic raw,
    String Function(String) labelBuilder, {
    String keyName = 'status',
  }) {
    final list = _asListOfMap(raw);
    return list
        .map((item) {
          final key = item[keyName]?.toString() ?? '';
          final value = _asDouble(item['count']) ?? 0;
          return _ChartBarItem(
            label: labelBuilder(key),
            value: value,
            valueText: value.toStringAsFixed(0),
          );
        })
        .where((item) => item.value > 0)
        .toList();
  }

  List<_ChartBarItem> _buildTopItems(
    dynamic raw, {
    required String labelKey,
    required String valueKey,
    String? subtitleKey,
    String subtitleSuffix = '',
    String valueSuffix = '',
  }) {
    final list = _asListOfMap(raw);
    return list
        .map((item) {
          final value = _asDouble(item[valueKey]) ?? 0;
          final subtitleRaw =
              subtitleKey == null ? null : _asDouble(item[subtitleKey]);
          final subtitle = subtitleRaw == null
              ? null
              : subtitleRaw.toStringAsFixed(1) + subtitleSuffix;
          return _ChartBarItem(
            label: item[labelKey]?.toString() ?? _emptyText,
            value: value,
            valueText: value.toStringAsFixed(0) + valueSuffix,
            subtitle: subtitle,
          );
        })
        .where((item) => item.value > 0)
        .take(5)
        .toList();
  }

  List<_ChartBarItem> _buildEfficiencyItems(Map<String, dynamic> stats) {
    final processCompletion = _asDouble(
        _readNested(stats, ['efficiency_analysis', 'process_completion_rate']));
    final taskCompletion = _asDouble(
        _readNested(stats, ['efficiency_analysis', 'task_completion_rate']));
    final defectiveRate = _asDouble(
        _readNested(stats, ['efficiency_analysis', 'defective_rate']));

    final items = <_ChartBarItem>[
      if (processCompletion != null)
        _ChartBarItem(
          label: '工序完成率',
          value: processCompletion,
          valueText: '${processCompletion.toStringAsFixed(1)}%',
        ),
      if (taskCompletion != null)
        _ChartBarItem(
          label: '任务完成率',
          value: taskCompletion,
          valueText: '${taskCompletion.toStringAsFixed(1)}%',
        ),
      if (defectiveRate != null)
        _ChartBarItem(
          label: '不良品率',
          value: defectiveRate,
          valueText: '${defectiveRate.toStringAsFixed(1)}%',
        ),
    ];
    return items;
  }

  List<Map<String, dynamic>> _asListOfMap(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  Object? _readNested(Map<String, dynamic> source, List<String> keys) {
    Object? current = source;
    for (final key in keys) {
      if (current is Map<String, dynamic>) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }

  double? _asDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  String _workOrderStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return '待开始';
      case 'in_progress':
        return '进行中';
      case 'paused':
        return '已暂停';
      case 'completed':
        return '已完成';
      case 'cancelled':
        return '已取消';
      default:
        return status.isEmpty ? _emptyText : status;
    }
  }

  String _taskStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return '待开始';
      case 'in_progress':
        return '进行中';
      case 'completed':
        return '已完成';
      case 'cancelled':
        return '已取消';
      default:
        return status.isEmpty ? _emptyText : status;
    }
  }

  String _priorityLabel(String priority) {
    switch (priority) {
      case 'low':
        return '低';
      case 'normal':
        return '普通';
      case 'high':
        return '高';
      case 'urgent':
        return '紧急';
      default:
        return priority.isEmpty ? _emptyText : priority;
    }
  }
}

class _ChartCardData {
  const _ChartCardData({
    required this.title,
    required this.items,
    this.totalOverride,
    this.showPercent = true,
  });

  final String title;
  final List<_ChartBarItem> items;
  final double? totalOverride;
  final bool showPercent;
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.items,
    required this.surface,
    required this.borderColor,
    required this.subtleText,
    required this.accent,
    required this.primary,
    this.totalOverride,
    this.showPercent = true,
  });

  final String title;
  final List<_ChartBarItem> items;
  final Color surface;
  final Color borderColor;
  final Color subtleText;
  final Color accent;
  final Color primary;
  final double? totalOverride;
  final bool showPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        LayoutTokens.gapMd,
        LayoutTokens.gapMd,
        LayoutTokens.gapMd,
        LayoutTokens.gapMd,
      ),
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: borderColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
          ),
          SizedBox(height: LayoutTokens.gapMd),
          _ChartBarList(
            items: items,
            totalOverride: totalOverride,
            showPercent: showPercent,
            primary: primary,
            subtleText: subtleText,
            accent: accent,
            borderColor: borderColor,
          ),
        ],
      ),
    );
  }
}

class _ChartBarItem {
  const _ChartBarItem({
    required this.label,
    required this.value,
    required this.valueText,
    this.subtitle,
  });

  final String label;
  final double value;
  final String valueText;
  final String? subtitle;
}

class _ChartBarList extends StatelessWidget {
  const _ChartBarList({
    required this.items,
    required this.primary,
    required this.subtleText,
    required this.accent,
    required this.borderColor,
    this.totalOverride,
    this.showPercent = true,
  });

  final List<_ChartBarItem> items;
  final Color primary;
  final Color subtleText;
  final Color accent;
  final Color borderColor;
  final double? totalOverride;
  final bool showPercent;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text('暂无数据', style: Theme.of(context).textTheme.bodySmall);
    }
    final total =
        totalOverride ?? items.fold<double>(0, (sum, item) => sum + item.value);

    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: EdgeInsets.only(
              bottom: LayoutTokens.gapSm + LayoutTokens.gapXs,
            ),
            child: _ChartBarRow(
              item: item,
              total: total,
              showPercent: showPercent,
              primary: primary,
              subtleText: subtleText,
              accent: accent,
              borderColor: borderColor,
            ),
          ),
      ],
    );
  }
}

class _ChartBarRow extends StatelessWidget {
  const _ChartBarRow({
    required this.item,
    required this.total,
    required this.showPercent,
    required this.primary,
    required this.subtleText,
    required this.accent,
    required this.borderColor,
  });

  final _ChartBarItem item;
  final double total;
  final bool showPercent;
  final Color primary;
  final Color subtleText;
  final Color accent;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final percent =
        total > 0 ? (item.value / total).clamp(0.0, 1.0).toDouble() : 0.0;
    final percentText = '${(percent * 100).toStringAsFixed(1)}%';
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: LayoutTokens.gapSm),
            Text(
              item.valueText,
              style: textTheme.bodySmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showPercent) ...[
              SizedBox(width: LayoutTokens.gapSm),
              Text(
                percentText,
                style: textTheme.bodySmall?.copyWith(
                  color: subtleText,
                ),
              ),
            ],
          ],
        ),
        if (item.subtitle != null) ...[
          SizedBox(height: LayoutTokens.gapXs / 2),
          Text(
            item.subtitle!,
            style: textTheme.labelSmall?.copyWith(
              color: subtleText,
            ),
          ),
        ],
        SizedBox(height: LayoutTokens.gapSm),
        Container(
          height: LayoutTokens.gapSm,
          decoration: BoxDecoration(
            color: borderColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(LayoutTokens.radiusXs),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percent,
            child: Container(
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(LayoutTokens.radiusXs),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardErrorCard extends StatelessWidget {
  const _DashboardErrorCard({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(LayoutTokens.gapLg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(child: Text(message)),
          SizedBox(width: LayoutTokens.gapMd),
          FilledButton(
            onPressed: onRetry,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}

class _StatMetric {
  const _StatMetric({
    required this.title,
    required this.value,
    this.subtitle,
  });

  final String title;
  final String value;
  final String? subtitle;
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.surface,
    required this.borderColor,
    required this.subtleText,
    required this.accent,
    required this.primary,
  });

  final String title;
  final String value;
  final String? subtitle;
  final Color surface;
  final Color borderColor;
  final Color subtleText;
  final Color accent;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        LayoutTokens.gapMd,
        LayoutTokens.gapMd,
        LayoutTokens.gapMd,
        LayoutTokens.gapMd,
      ),
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: borderColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: subtleText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: LayoutTokens.gapSm),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: LayoutTokens.gapXs),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: subtleText,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.accent,
    required this.borderColor,
    required this.surface,
  });

  final String title;
  final String subtitle;
  final Color primary;
  final Color accent;
  final Color borderColor;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        LayoutTokens.gapLg + LayoutTokens.gapXs,
        LayoutTokens.gapLg,
        LayoutTokens.gapLg + LayoutTokens.gapXs,
        LayoutTokens.gapLg,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusXl),
        border: Border.all(color: borderColor),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final badgeWrap = Wrap(
            spacing: LayoutTokens.gapSm + LayoutTokens.gapXs,
            runSpacing: LayoutTokens.gapSm + LayoutTokens.gapXs,
            children: [
              _TinyBadge(
                label: subtitle,
                color: accent,
                background: primary.withValues(alpha: 0.08),
              ),
            ],
          );

          final titleBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                  ),
                  child: Icon(
                    Icons.dashboard_outlined,
                    color: primary,
                    size: LayoutTokens.iconMd,
                  ),
                ),
                SizedBox(height: LayoutTokens.gapMd),
                titleBlock,
                SizedBox(height: LayoutTokens.gapMd),
                badgeWrap,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                ),
                child: Icon(
                  Icons.dashboard_outlined,
                  color: primary,
                  size: LayoutTokens.iconMd,
                ),
              ),
              SizedBox(width: LayoutTokens.gapMd),
              Expanded(child: titleBlock),
              SizedBox(width: LayoutTokens.gapSm + LayoutTokens.gapXs),
              badgeWrap,
            ],
          );
        },
      ),
    );
  }
}

class _QuickEntrySection extends StatelessWidget {
  const _QuickEntrySection({
    required this.entries,
    required this.surface,
    required this.borderColor,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final List<NavItem> entries;
  final Color surface;
  final Color borderColor;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return _PanelShell(
      title: '常用入口',
      subtitle: '优先处理高频操作。',
      surface: surface,
      borderColor: borderColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          return Wrap(
            spacing: LayoutTokens.gapMd,
            runSpacing: LayoutTokens.gapMd,
            children: [
              for (final item in entries)
                _QuickEntryCard(
                  item: item,
                  width: compact
                      ? constraints.maxWidth
                      : (constraints.maxWidth - LayoutTokens.gapMd) / 2,
                  accent: accent,
                  subtleText: subtleText,
                  primary: primary,
                  borderColor: borderColor,
                  surface: surface,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SimpleModuleSection extends StatelessWidget {
  const _SimpleModuleSection({
    required this.entries,
    required this.surface,
    required this.borderColor,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final List<NavItem> entries;
  final Color surface;
  final Color borderColor;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return _PanelShell(
      title: '常用模块',
      subtitle: '少量保留，避免首页过载。',
      surface: surface,
      borderColor: borderColor,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _SimpleNavRow(
              item: entries[i],
              accent: accent,
              subtleText: subtleText,
              primary: primary,
            ),
            if (i != entries.length - 1)
              Divider(height: 20, color: borderColor),
          ],
        ],
      ),
    );
  }
}

class _GroupPanel extends StatelessWidget {
  const _GroupPanel({
    required this.groups,
    required this.surface,
    required this.borderColor,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final List<NavItem> groups;
  final Color surface;
  final Color borderColor;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return _PanelShell(
      title: '全部模块',
      subtitle: '按模块进入处理。',
      surface: surface,
      borderColor: borderColor,
      child: Column(
        children: [
          for (var i = 0; i < groups.length; i++) ...[
            _GroupRow(
              group: groups[i],
              accent: accent,
              subtleText: subtleText,
              primary: primary,
            ),
            if (i != groups.length - 1) Divider(height: 22, color: borderColor),
          ],
        ],
      ),
    );
  }
}

class _ContentArea extends StatelessWidget {
  const _ContentArea({
    required this.selectedId,
    required this.style,
    required this.bodyBuilder,
  });

  final String selectedId;
  final ContentAreaStyle style;
  final ContentBodyBuilder? bodyBuilder;

  @override
  Widget build(BuildContext context) {
    final padding = LayoutTokens.pagePadding(context);
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bodyBuilder != null)
            bodyBuilder!(context, style)
          else
            _ModulePlaceholder(
              title: labelFor(selectedId),
              style: style,
            ),
        ],
      ),
    );
  }
}

class _ModulePlaceholder extends StatelessWidget {
  const _ModulePlaceholder({
    required this.title,
    required this.style,
  });

  final String title;
  final ContentAreaStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = LayoutTokens.cardPadding(context);
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: style.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: style.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: style.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '当前模块入口已接入统一布局。',
            style: theme.textTheme.bodySmall?.copyWith(color: style.subtleText),
          ),
        ],
      ),
    );
  }
}

class _PanelShell extends StatelessWidget {
  const _PanelShell({
    required this.title,
    required this.subtitle,
    required this.surface,
    required this.borderColor,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Color surface;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final padding = LayoutTokens.cardPadding(context);

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.sidebarText,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle.trim().isNotEmpty) ...[
            SizedBox(height: LayoutTokens.gapXs / 2 + 1),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.subtleText,
                height: 1.35,
              ),
            ),
            SizedBox(height: LayoutTokens.gapMd + LayoutTokens.gapXs / 2),
          ] else
            SizedBox(height: LayoutTokens.gapMd),
          child,
        ],
      ),
    );
  }
}

class _QuickEntryCard extends StatelessWidget {
  const _QuickEntryCard({
    required this.item,
    required this.width,
    required this.accent,
    required this.subtleText,
    required this.primary,
    required this.borderColor,
    required this.surface,
  });

  final NavItem item;
  final double width;
  final Color accent;
  final Color subtleText;
  final Color primary;
  final Color borderColor;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.path == null ? null : () => context.go(item.path!),
      borderRadius: BorderRadius.circular(LayoutTokens.radiusXl),
      child: Container(
        width: width,
        padding: EdgeInsets.all(LayoutTokens.gapLg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          border: Border.all(color: borderColor),
          color: surface,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
              ),
              child: Icon(item.icon, color: primary, size: LayoutTokens.iconMd),
            ),
            SizedBox(width: LayoutTokens.gapMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '进入处理',
                    style: TextStyle(color: subtleText, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: subtleText,
              size: LayoutTokens.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleNavRow extends StatelessWidget {
  const _SimpleNavRow({
    required this.item,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final NavItem item;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.path == null ? null : () => context.go(item.path!),
      borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: LayoutTokens.gapXs),
        child: Row(
          children: [
            Icon(item.icon, size: LayoutTokens.iconMd, color: primary),
            SizedBox(width: LayoutTokens.gapSm + LayoutTokens.gapXs),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '进入',
              style: TextStyle(color: subtleText, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupRow extends StatelessWidget {
  const _GroupRow({
    required this.group,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final NavItem group;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(group.icon, size: LayoutTokens.iconMd, color: primary),
            SizedBox(width: LayoutTokens.gapSm + LayoutTokens.gapXs),
            Text(
              group.label,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: LayoutTokens.gapMd),
        Wrap(
          spacing: LayoutTokens.gapSm + LayoutTokens.gapXs,
          runSpacing: LayoutTokens.gapSm + LayoutTokens.gapXs,
          children: [
            for (final child in group.children)
              _RoutePill(
                item: child,
                primary: primary,
                subtleText: subtleText,
              ),
          ],
        ),
      ],
    );
  }
}

class _RoutePill extends StatelessWidget {
  const _RoutePill({
    required this.item,
    required this.primary,
    required this.subtleText,
  });

  final NavItem item;
  final Color primary;
  final Color subtleText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: item.path == null ? null : () => context.go(item.path!),
      borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: LayoutTokens.gapMd,
          vertical: LayoutTokens.gapSm,
        ),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
        ),
        child: Text(
          item.label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: subtleText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: LayoutTokens.gapMd,
        vertical: LayoutTokens.gapSm,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
