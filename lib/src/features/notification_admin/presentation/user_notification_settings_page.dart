import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/widgets/notification_admin_widgets.dart';

class UserNotificationSettingsPage extends StatefulWidget {
  const UserNotificationSettingsPage({super.key});

  @override
  State<UserNotificationSettingsPage> createState() =>
      _UserNotificationSettingsPageState();
}

class _UserNotificationSettingsPageState
    extends State<UserNotificationSettingsPage> {
  ApiClient? _apiClient;
  AuthController? _authController;
  bool _loading = false;
  bool _saving = false;

  bool _emailNotifications = true;
  bool _websocketNotifications = true;
  bool _taskAssignments = true;
  bool _processCompletions = true;
  bool _deadlineWarnings = true;
  bool _systemAnnouncements = true;
  bool _quietHoursEnabled = false;
  bool _showAdvanced = false;

  final TextEditingController _urgencyController = TextEditingController(
    text: 'normal',
  );
  final TextEditingController _quietStartController = TextEditingController(
    text: '22:00',
  );
  final TextEditingController _quietEndController = TextEditingController(
    text: '08:00',
  );

  Map<String, dynamic>? _lastResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiClient ??= context.read<ApiClient>();
    _authController ??= context.read<AuthController>();
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
      final response = await _runAuthorized(
        () => _apiClient!.get('/user-notification-settings/get_settings/'),
      );
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
      _showRequestError('获取设置失败', err);
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
      final response = await _runAuthorized(
        () => _apiClient!.post(
          '/user-notification-settings/update_settings/',
          data: payload,
        ),
      );
      setState(() => _lastResult = _asMap(response.data));
      ToastUtil.showSuccess('通知设置已保存');
    } catch (err) {
      _showRequestError('保存失败', err);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<T> _runAuthorized<T>(Future<T> Function() action) async {
    final auth = _authController;
    if (auth != null) {
      final valid = await auth.ensureValidSession();
      if (!valid) {
        throw const ApiException(message: '登录状态已失效，请重新登录', statusCode: 401);
      }
    }
    try {
      return await action();
    } on ApiException catch (err) {
      if (err.statusCode == 401 &&
          await (_apiClient?.refreshAccessToken() ?? Future.value(false))) {
        return action();
      }
      rethrow;
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
    ToastUtil.showError(message);
  }

  void _showRequestError(String prefix, Object err) {
    if (err is ApiException && err.statusCode == 401) {
      _showError('登录状态已失效，请重新登录');
      return;
    }
    _showError('$prefix: $err');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: LayoutTokens.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationAdminSection(
            title: '通知设置',
            child: NotificationFieldList(
              children: [
                SwitchListTile(
                  value: _websocketNotifications,
                  onChanged: (value) =>
                      setState(() => _websocketNotifications = value),
                  title: const Text('站内通知'),
                  subtitle: const Text('在系统内实时接收任务和公告提醒'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: _emailNotifications,
                  onChanged: (value) =>
                      setState(() => _emailNotifications = value),
                  title: const Text('邮件通知'),
                  subtitle: const Text('重要或达到阈值的通知通过邮件发送'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: _quietHoursEnabled,
                  onChanged: (value) =>
                      setState(() => _quietHoursEnabled = value),
                  title: const Text('启用免打扰时间'),
                  contentPadding: EdgeInsets.zero,
                ),
                if (_quietHoursEnabled)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _quietStartController,
                          decoration: const InputDecoration(labelText: '开始时间'),
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.sm),
                      Expanded(
                        child: TextField(
                          controller: _quietEndController,
                          decoration: const InputDecoration(labelText: '结束时间'),
                        ),
                      ),
                    ],
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () =>
                        setState(() => _showAdvanced = !_showAdvanced),
                    icon: Icon(
                      _showAdvanced ? Icons.expand_less : Icons.expand_more,
                    ),
                    label: Text(_showAdvanced ? '收起高级规则' : '展开高级规则'),
                  ),
                ),
                if (_showAdvanced) _buildAdvancedSettings(context),
                Wrap(
                  spacing: SpacingTokens.sm,
                  runSpacing: SpacingTokens.sm,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _loading ? null : _loadSettings,
                      icon: NotificationLoadingIcon(
                        loading: _loading,
                        icon: Icons.refresh,
                      ),
                      label: Text(_loading ? '获取中' : '刷新'),
                    ),
                    FilledButton.icon(
                      onPressed: _saving ? null : _saveSettings,
                      icon: NotificationLoadingIcon(
                        loading: _saving,
                        icon: Icons.save_outlined,
                      ),
                      label: Text(_saving ? '保存中' : '保存'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(BuildContext context) {
    return NotificationFieldList(
      children: [
        AppSelect<String>(
          key: ValueKey<String>('urgency-${_urgencyController.text}'),
          value: _urgencyController.text,
          decoration: const InputDecoration(labelText: '邮件通知阈值'),
          options: const [
            AppDropdownOption(value: 'low', label: '低及以上'),
            AppDropdownOption(value: 'normal', label: '普通及以上'),
            AppDropdownOption(value: 'high', label: '重要及以上'),
            AppDropdownOption(value: 'urgent', label: '仅紧急'),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => _urgencyController.text = value);
          },
        ),
        SwitchListTile(
          value: _taskAssignments,
          onChanged: (value) => setState(() => _taskAssignments = value),
          title: const Text('任务分配通知'),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          value: _processCompletions,
          onChanged: (value) => setState(() => _processCompletions = value),
          title: const Text('工序完成通知'),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          value: _deadlineWarnings,
          onChanged: (value) => setState(() => _deadlineWarnings = value),
          title: const Text('交期预警通知'),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          value: _systemAnnouncements,
          onChanged: (value) => setState(() => _systemAnnouncements = value),
          title: const Text('系统公告通知'),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
