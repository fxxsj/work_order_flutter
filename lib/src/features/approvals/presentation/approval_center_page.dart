import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';

class ApprovalCenterPage extends StatefulWidget {
  const ApprovalCenterPage({super.key});

  @override
  State<ApprovalCenterPage> createState() => _ApprovalCenterPageState();
}

class _ApprovalCenterPageState extends State<ApprovalCenterPage> {
  final TextEditingController _orderIdController = TextEditingController();
  ApiClient? _apiClient;

  bool _loadingSubmit = false;
  bool _loadingDetermine = false;
  bool _loadingStatus = false;
  bool _loadingTasks = false;

  Map<String, dynamic>? _submitResult;
  Map<String, dynamic>? _determineResult;
  Map<String, dynamic>? _statusResult;
  Map<String, dynamic>? _tasksResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiClient ??= context.read<ApiClient>();
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    super.dispose();
  }

  int? _orderId() {
    final value = _orderIdController.text.trim();
    return int.tryParse(value);
  }

  Future<void> _submitForApproval() async {
    final orderId = _orderId();
    if (orderId == null) {
      _showError('请输入有效的施工单ID');
      return;
    }
    setState(() => _loadingSubmit = true);
    try {
      final response = await _apiClient!.post(
        '/multi-level-approval/submit_for_approval/',
        data: {'order_id': orderId},
      );
      setState(() => _submitResult = _asMap(response.data));
    } catch (err) {
      _showError('提交失败: $err');
    } finally {
      if (mounted) setState(() => _loadingSubmit = false);
    }
  }

  Future<void> _determineWorkflow() async {
    final orderId = _orderId();
    if (orderId == null) {
      _showError('请输入有效的施工单ID');
      return;
    }
    setState(() => _loadingDetermine = true);
    try {
      final response = await _apiClient!.post(
        '/multi-level-approval/determine_workflow/',
        data: {'order_id': orderId},
      );
      setState(() => _determineResult = _asMap(response.data));
    } catch (err) {
      _showError('获取失败: $err');
    } finally {
      if (mounted) setState(() => _loadingDetermine = false);
    }
  }

  Future<void> _loadApprovalStatus() async {
    final orderId = _orderId();
    if (orderId == null) {
      _showError('请输入有效的施工单ID');
      return;
    }
    setState(() => _loadingStatus = true);
    try {
      final response = await _apiClient!.get(
        '/multi-level-approval/get_approval_status/',
        queryParameters: {'order_id': orderId},
      );
      setState(() => _statusResult = _asMap(response.data));
    } catch (err) {
      _showError('获取失败: $err');
    } finally {
      if (mounted) setState(() => _loadingStatus = false);
    }
  }

  Future<void> _loadMyTasks() async {
    setState(() => _loadingTasks = true);
    try {
      final response = await _apiClient!.get(
        '/multi-level-approval/get_my_tasks/',
      );
      setState(() => _tasksResult = _asMap(response.data));
    } catch (err) {
      _showError('获取失败: $err');
    } finally {
      if (mounted) setState(() => _loadingTasks = false);
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
          _buildOrderInputCard(),
          SizedBox(height: spacing),
          _buildActionCard(
            title: '提交审核',
            description: '提交指定施工单进入多级审批流程。',
            loading: _loadingSubmit,
            onPressed: _submitForApproval,
            result: _submitResult,
          ),
          SizedBox(height: spacing),
          _buildActionCard(
            title: '确定工作流',
            description: '根据施工单信息判断适用的审批工作流。',
            loading: _loadingDetermine,
            onPressed: _determineWorkflow,
            result: _determineResult,
          ),
          SizedBox(height: spacing),
          _buildActionCard(
            title: '审批状态',
            description: '查看施工单当前审批状态。',
            loading: _loadingStatus,
            onPressed: _loadApprovalStatus,
            result: _statusResult,
          ),
          SizedBox(height: spacing),
          _buildActionCard(
            title: '我的审核任务',
            description: '获取当前用户待处理的审批任务。',
            loading: _loadingTasks,
            onPressed: _loadMyTasks,
            result: _tasksResult,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInputCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('施工单ID', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _orderIdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '输入施工单ID',
              prefixIcon: Icon(Icons.description_outlined),
            ),
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
