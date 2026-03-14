import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';

class UrgentOrderPage extends StatefulWidget {
  const UrgentOrderPage({super.key});

  @override
  State<UrgentOrderPage> createState() => _UrgentOrderPageState();
}

class _UrgentOrderPageState extends State<UrgentOrderPage> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  ApiClient? _apiClient;
  bool _loadingMark = false;
  bool _loadingList = false;
  bool _loadingEscalations = false;

  Map<String, dynamic>? _markResult;
  Map<String, dynamic>? _listResult;
  Map<String, dynamic>? _escalationResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiClient ??= context.read<ApiClient>();
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  int? _orderId() {
    return int.tryParse(_orderIdController.text.trim());
  }

  Future<void> _markUrgent() async {
    final orderId = _orderId();
    if (orderId == null) {
      _showError('请输入有效的施工单ID');
      return;
    }
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      _showError('请输入紧急原因');
      return;
    }
    setState(() => _loadingMark = true);
    try {
      final response = await _apiClient!.post(
        '/urgent-orders/mark_urgent/',
        data: {'order_id': orderId, 'reason': reason},
      );
      setState(() => _markResult = _asMap(response.data));
    } catch (err) {
      _showError('标记失败: $err');
    } finally {
      if (mounted) setState(() => _loadingMark = false);
    }
  }

  Future<void> _loadUrgentOrders() async {
    setState(() => _loadingList = true);
    try {
      final response = await _apiClient!.get('/urgent-orders/get_urgent_orders/');
      setState(() => _listResult = _asMap(response.data));
    } catch (err) {
      _showError('获取失败: $err');
    } finally {
      if (mounted) setState(() => _loadingList = false);
    }
  }

  Future<void> _loadEscalations() async {
    setState(() => _loadingEscalations = true);
    try {
      final response = await _apiClient!.get('/urgent-orders/get_escalation_history/');
      setState(() => _escalationResult = _asMap(response.data));
    } catch (err) {
      _showError('获取失败: $err');
    } finally {
      if (mounted) setState(() => _loadingEscalations = false);
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
          _buildMarkCard(),
          SizedBox(height: spacing),
          _buildActionCard(
            title: '紧急订单列表',
            description: '查看当前紧急订单及数量。',
            loading: _loadingList,
            onPressed: _loadUrgentOrders,
            result: _listResult,
          ),
          SizedBox(height: spacing),
          _buildActionCard(
            title: '上报历史',
            description: '查看最近的上报记录。',
            loading: _loadingEscalations,
            onPressed: _loadEscalations,
            result: _escalationResult,
          ),
        ],
      ),
    );
  }

  Widget _buildMarkCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('标记紧急订单', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _orderIdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '施工单ID',
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              hintText: '紧急原因',
              prefixIcon: Icon(Icons.warning_amber_outlined),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: _loadingMark ? null : _markUrgent,
              icon: _loadingMark
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.priority_high, size: 18),
              label: Text(_loadingMark ? '提交中' : '标记紧急'),
            ),
          ),
          if (_markResult != null) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            _buildResult(_markResult!),
          ],
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
