import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';

class ApprovalReportPage extends StatefulWidget {
  const ApprovalReportPage({super.key});

  @override
  State<ApprovalReportPage> createState() => _ApprovalReportPageState();
}

class _ApprovalReportPageState extends State<ApprovalReportPage> {
  ApiClient? _apiClient;

  final TextEditingController _taskIdController = TextEditingController();
  final TextEditingController _workorderIdController = TextEditingController();
  final TextEditingController _departmentIdController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  bool _loadingStats = false;
  bool _loadingDashboard = false;
  bool _loadingSmartTask = false;
  bool _loadingSmartWorkorder = false;
  bool _loadingTeamSkill = false;
  bool _loadingUserPerformance = false;
  bool _loadingUpdateSkill = false;

  Map<String, dynamic>? _statsResult;
  Map<String, dynamic>? _dashboardResult;
  Map<String, dynamic>? _smartTaskResult;
  Map<String, dynamic>? _smartWorkorderResult;
  Map<String, dynamic>? _teamSkillResult;
  Map<String, dynamic>? _userPerformanceResult;
  Map<String, dynamic>? _updateSkillResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiClient ??= context.read<ApiClient>();
  }

  @override
  void dispose() {
    _taskIdController.dispose();
    _workorderIdController.dispose();
    _departmentIdController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  int? _parseId(TextEditingController controller) {
    return int.tryParse(controller.text.trim());
  }

  Future<void> _loadStats() async {
    setState(() => _loadingStats = true);
    try {
      final response = await _apiClient!.get('/approval-reports/get_statistics/');
      setState(() => _statsResult = _asMap(response.data));
    } catch (err) {
      _showError('获取统计失败: $err');
    } finally {
      if (mounted) setState(() => _loadingStats = false);
    }
  }

  Future<void> _loadDashboard() async {
    setState(() => _loadingDashboard = true);
    try {
      final response = await _apiClient!.get('/approval-reports/dashboard/');
      setState(() => _dashboardResult = _asMap(response.data));
    } catch (err) {
      _showError('获取仪表板失败: $err');
    } finally {
      if (mounted) setState(() => _loadingDashboard = false);
    }
  }

  Future<void> _smartAssignTask() async {
    final taskId = _parseId(_taskIdController);
    if (taskId == null) {
      _showError('请输入任务ID');
      return;
    }
    setState(() => _loadingSmartTask = true);
    try {
      final response = await _apiClient!.post(
        '/approval-reports/smart_assign_task/',
        data: {'task_id': taskId},
      );
      setState(() => _smartTaskResult = _asMap(response.data));
    } catch (err) {
      _showError('智能分配失败: $err');
    } finally {
      if (mounted) setState(() => _loadingSmartTask = false);
    }
  }

  Future<void> _smartAssignWorkorder() async {
    final workorderId = _parseId(_workorderIdController);
    if (workorderId == null) {
      _showError('请输入施工单ID');
      return;
    }
    setState(() => _loadingSmartWorkorder = true);
    try {
      final response = await _apiClient!.post(
        '/approval-reports/smart_assign_workorder/',
        data: {'workorder_id': workorderId},
      );
      setState(() => _smartWorkorderResult = _asMap(response.data));
    } catch (err) {
      _showError('智能分配失败: $err');
    } finally {
      if (mounted) setState(() => _loadingSmartWorkorder = false);
    }
  }

  Future<void> _loadTeamSkill() async {
    setState(() => _loadingTeamSkill = true);
    try {
      final departmentId = _parseId(_departmentIdController);
      final response = await _apiClient!.get(
        '/approval-reports/team_skill_analysis/',
        queryParameters: {
          if (departmentId != null) 'department_id': departmentId,
        },
      );
      setState(() => _teamSkillResult = _asMap(response.data));
    } catch (err) {
      _showError('获取团队技能失败: $err');
    } finally {
      if (mounted) setState(() => _loadingTeamSkill = false);
    }
  }

  Future<void> _loadUserPerformance() async {
    final userId = _parseId(_userIdController);
    if (userId == null) {
      _showError('请输入用户ID');
      return;
    }
    setState(() => _loadingUserPerformance = true);
    try {
      final response = await _apiClient!.get(
        '/approval-reports/user_performance_summary/',
        queryParameters: {'user_id': userId},
      );
      setState(() => _userPerformanceResult = _asMap(response.data));
    } catch (err) {
      _showError('获取绩效失败: $err');
    } finally {
      if (mounted) setState(() => _loadingUserPerformance = false);
    }
  }

  Future<void> _updateSkillProfile() async {
    setState(() => _loadingUpdateSkill = true);
    try {
      final response = await _apiClient!.post('/approval-reports/update_skill_profile/');
      setState(() => _updateSkillResult = _asMap(response.data));
    } catch (err) {
      _showError('更新失败: $err');
    } finally {
      if (mounted) setState(() => _loadingUpdateSkill = false);
    }
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return {'data': value};
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final spacing = LayoutTokens.sectionSpacing(context);
    return SingleChildScrollView(
      padding: LayoutTokens.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionCard(
            title: '审批统计',
            description: '获取审批整体统计数据。',
            loading: _loadingStats,
            onPressed: _loadStats,
            result: _statsResult,
          ),
          SizedBox(height: spacing),
          _buildActionCard(
            title: '审批仪表板',
            description: '获取审批实时指标。',
            loading: _loadingDashboard,
            onPressed: _loadDashboard,
            result: _dashboardResult,
          ),
          SizedBox(height: spacing),
          _buildInputActionCard(
            title: '智能分配任务',
            hintText: '任务ID',
            controller: _taskIdController,
            loading: _loadingSmartTask,
            onPressed: _smartAssignTask,
            result: _smartTaskResult,
          ),
          SizedBox(height: spacing),
          _buildInputActionCard(
            title: '智能分配施工单',
            hintText: '施工单ID',
            controller: _workorderIdController,
            loading: _loadingSmartWorkorder,
            onPressed: _smartAssignWorkorder,
            result: _smartWorkorderResult,
          ),
          SizedBox(height: spacing),
          _buildInputActionCard(
            title: '团队技能分析',
            hintText: '部门ID（可选）',
            controller: _departmentIdController,
            loading: _loadingTeamSkill,
            onPressed: _loadTeamSkill,
            result: _teamSkillResult,
          ),
          SizedBox(height: spacing),
          _buildInputActionCard(
            title: '用户绩效统计',
            hintText: '用户ID',
            controller: _userIdController,
            loading: _loadingUserPerformance,
            onPressed: _loadUserPerformance,
            result: _userPerformanceResult,
          ),
          SizedBox(height: spacing),
          _buildActionCard(
            title: '更新技能画像',
            description: '更新用户技能档案（当前接口可能未启用）。',
            loading: _loadingUpdateSkill,
            onPressed: _updateSkillProfile,
            result: _updateSkillResult,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String description,
    required bool loading,
    required VoidCallback onPressed,
    Map<String, dynamic>? result,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: LayoutTokens.gapXs),
          Text(description, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: LayoutTokens.gapSm),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: loading ? null : onPressed,
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh, size: 18),
              label: Text(loading ? '获取中' : '获取'),
            ),
          ),
          if (result != null) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            _buildResult(result),
          ],
        ],
      ),
    );
  }

  Widget _buildInputActionCard({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required bool loading,
    required VoidCallback onPressed,
    Map<String, dynamic>? result,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.numbers_outlined),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: loading ? null : onPressed,
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_circle_outline, size: 18),
              label: Text(loading ? '执行中' : '执行'),
            ),
          ),
          if (result != null) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            _buildResult(result),
          ],
        ],
      ),
    );
  }

  Widget _buildResult(Map<String, dynamic> result) {
    final pretty = const JsonEncoder.withIndent('  ').convert(result);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(LayoutTokens.gapSm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      ),
      child: SelectableText(pretty, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
