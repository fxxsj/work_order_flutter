import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';

class UserNotificationSettingsPage extends StatefulWidget {
  const UserNotificationSettingsPage({super.key});

  @override
  State<UserNotificationSettingsPage> createState() =>
      _UserNotificationSettingsPageState();
}

class _UserNotificationSettingsPageState
    extends State<UserNotificationSettingsPage> {
  ApiClient? _apiClient;
  bool _loading = false;
  bool _saving = false;

  bool _emailNotifications = true;
  bool _websocketNotifications = true;
  bool _taskAssignments = true;
  bool _processCompletions = true;
  bool _deadlineWarnings = true;
  bool _systemAnnouncements = true;
  bool _quietHoursEnabled = false;

  final TextEditingController _urgencyController =
      TextEditingController(text: 'normal');
  final TextEditingController _quietStartController =
      TextEditingController(text: '22:00');
  final TextEditingController _quietEndController =
      TextEditingController(text: '08:00');

  Map<String, dynamic>? _lastResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiClient ??= context.read<ApiClient>();
    if (_lastResult == null) {
      _loadSettings();
    }
  }

  @override
  void dispose() {
    _urgencyController.dispose();
    _quietStartController.dispose();
    _quietEndController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _loading = true);
    try {
      final response =
          await _apiClient!.get('/user-notification-settings/get_settings/');
      final data = _asMap(response.data);
      setState(() {
        _emailNotifications = data['email_notifications'] == true;
        _websocketNotifications = data['websocket_notifications'] == true;
        _taskAssignments = data['task_assignments'] == true;
        _processCompletions = data['process_completions'] == true;
        _deadlineWarnings = data['deadline_warnings'] == true;
        _systemAnnouncements = data['system_announcements'] == true;
        _quietHoursEnabled = data['quiet_hours_enabled'] == true;
        _urgencyController.text =
            data['urgency_threshold']?.toString() ?? 'normal';
        _quietStartController.text =
            data['quiet_hours_start']?.toString() ?? '22:00';
        _quietEndController.text =
            data['quiet_hours_end']?.toString() ?? '08:00';
        _lastResult = data;
      });
    } catch (err) {
      _showError('获取设置失败: $err');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _saving = true);
    try {
      final payload = {
        'email_notifications': _emailNotifications,
        'websocket_notifications': _websocketNotifications,
        'task_assignments': _taskAssignments,
        'process_completions': _processCompletions,
        'deadline_warnings': _deadlineWarnings,
        'system_announcements': _systemAnnouncements,
        'urgency_threshold': _urgencyController.text.trim(),
        'quiet_hours_enabled': _quietHoursEnabled,
        'quiet_hours_start': _quietStartController.text.trim(),
        'quiet_hours_end': _quietEndController.text.trim(),
      };
      final response = await _apiClient!.post(
        '/user-notification-settings/update_settings/',
        data: payload,
      );
      setState(() => _lastResult = _asMap(response.data));
    } catch (err) {
      _showError('保存失败: $err');
    } finally {
      if (mounted) setState(() => _saving = false);
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
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('通知设置', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: LayoutTokens.gapSm),
                SwitchListTile(
                  value: _emailNotifications,
                  onChanged: (value) =>
                      setState(() => _emailNotifications = value),
                  title: const Text('邮件通知'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: _websocketNotifications,
                  onChanged: (value) =>
                      setState(() => _websocketNotifications = value),
                  title: const Text('站内通知'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: _taskAssignments,
                  onChanged: (value) => setState(() => _taskAssignments = value),
                  title: const Text('任务分配通知'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: _processCompletions,
                  onChanged: (value) =>
                      setState(() => _processCompletions = value),
                  title: const Text('工序完成通知'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: _deadlineWarnings,
                  onChanged: (value) =>
                      setState(() => _deadlineWarnings = value),
                  title: const Text('交期预警通知'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: _systemAnnouncements,
                  onChanged: (value) =>
                      setState(() => _systemAnnouncements = value),
                  title: const Text('系统公告通知'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: LayoutTokens.gapSm),
                TextField(
                  controller: _urgencyController,
                  decoration: const InputDecoration(
                    hintText: '紧急阈值',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                ),
                const SizedBox(height: LayoutTokens.gapSm),
                SwitchListTile(
                  value: _quietHoursEnabled,
                  onChanged: (value) =>
                      setState(() => _quietHoursEnabled = value),
                  title: const Text('启用免打扰时间'),
                  contentPadding: EdgeInsets.zero,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _quietStartController,
                        decoration: const InputDecoration(
                          hintText: '开始时间',
                        ),
                      ),
                    ),
                    const SizedBox(width: LayoutTokens.gapSm),
                    Expanded(
                      child: TextField(
                        controller: _quietEndController,
                        decoration: const InputDecoration(
                          hintText: '结束时间',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LayoutTokens.gapSm),
                Wrap(
                  spacing: LayoutTokens.gapSm,
                  runSpacing: LayoutTokens.gapSm,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _loading ? null : _loadSettings,
                      icon: _loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh, size: 18),
                      label: Text(_loading ? '获取中' : '刷新'),
                    ),
                    FilledButton.icon(
                      onPressed: _saving ? null : _saveSettings,
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined, size: 18),
                      label: Text(_saving ? '保存中' : '保存'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_lastResult != null) ...[
            SizedBox(height: spacing),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('返回结果', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: LayoutTokens.gapSm),
                  _buildResult(_lastResult!),
                ],
              ),
            ),
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
