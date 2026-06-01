import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/widgets/notification_admin_widgets.dart';

class SystemNotificationPage extends StatefulWidget {
  const SystemNotificationPage({super.key});

  @override
  State<SystemNotificationPage> createState() => _SystemNotificationPageState();
}

class _SystemNotificationPageState extends State<SystemNotificationPage> {
  ApiClient? _apiClient;
  AuthController? _authController;
  bool _initialized = false;

  final TextEditingController _announcementTitleController =
      TextEditingController();
  final TextEditingController _announcementContentController =
      TextEditingController();
  final TextEditingController _announcementRecipientsController =
      TextEditingController();
  final TextEditingController _announcementExpiresController =
      TextEditingController();
  bool _announcementOnlyStaff = false;

  final TextEditingController _alertTitleController = TextEditingController();
  final TextEditingController _alertContentController = TextEditingController();
  final TextEditingController _alertRecipientsController =
      TextEditingController();
  bool _alertOnlyStaff = false;

  final TextEditingController _settingsJsonController = TextEditingController();

  String _notificationType = 'announcement';
  bool _showAdvanced = false;
  bool _loadingAnnouncement = false;
  bool _loadingAlert = false;
  bool _loadingSettings = false;
  bool _loadingStatus = false;
  bool _loadingUpdateSettings = false;

  Map<String, dynamic>? _announcementResult;
  Map<String, dynamic>? _alertResult;
  Map<String, dynamic>? _settingsResult;
  Map<String, dynamic>? _statusResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiClient ??= context.read<ApiClient>();
    _authController ??= context.read<AuthController>();
    if (!_initialized) {
      _initialized = true;
      Future.microtask(() async {
        await _loadSettings();
        await _loadStatus();
      });
    }
  }

  @override
  void dispose() {
    _announcementTitleController.dispose();
    _announcementContentController.dispose();
    _announcementRecipientsController.dispose();
    _announcementExpiresController.dispose();
    _alertTitleController.dispose();
    _alertContentController.dispose();
    _alertRecipientsController.dispose();
    _settingsJsonController.dispose();
    super.dispose();
  }

  Future<void> _createAnnouncement() async {
    final title = _announcementTitleController.text.trim();
    final content = _announcementContentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      _showError('请输入公告标题和内容');
      return;
    }
    setState(() => _loadingAnnouncement = true);
    try {
      final data = <String, dynamic>{
        'title': title,
        'content': content,
        'only_staff': _announcementOnlyStaff,
      };
      final recipients = _parseIds(_announcementRecipientsController.text);
      if (recipients.isNotEmpty) {
        data['recipient_ids'] = recipients;
      }
      final expires = int.tryParse(_announcementExpiresController.text.trim());
      if (expires != null) {
        data['expires_in_days'] = expires;
      }
      final response = await _runAuthorized(
        () => _apiClient!.post(
          '/system-notifications/create_announcement/',
          data: data,
        ),
      );
      setState(() => _announcementResult = _asMap(response.data));
    } catch (err) {
      _showRequestError('发送失败', err);
    } finally {
      if (mounted) setState(() => _loadingAnnouncement = false);
    }
  }

  Future<void> _sendUrgentAlert() async {
    final title = _alertTitleController.text.trim();
    final content = _alertContentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      _showError('请输入警报标题和内容');
      return;
    }
    setState(() => _loadingAlert = true);
    try {
      final data = <String, dynamic>{
        'title': title,
        'content': content,
        'only_staff': _alertOnlyStaff,
      };
      final recipients = _parseIds(_alertRecipientsController.text);
      if (recipients.isNotEmpty) {
        data['recipient_ids'] = recipients;
      }
      final response = await _runAuthorized(
        () => _apiClient!.post(
          '/system-notifications/send_urgent_alert/',
          data: data,
        ),
      );
      setState(() => _alertResult = _asMap(response.data));
    } catch (err) {
      _showRequestError('发送失败', err);
    } finally {
      if (mounted) setState(() => _loadingAlert = false);
    }
  }

  Future<void> _loadSettings() async {
    setState(() => _loadingSettings = true);
    try {
      final response = await _runAuthorized(
        () => _apiClient!.get('/system-notifications/notification_settings/'),
      );
      final data = _asMap(response.data);
      setState(() {
        _settingsResult = data;
        _settingsJsonController.text = const JsonEncoder.withIndent(
          '  ',
        ).convert(data);
      });
    } catch (err) {
      _showRequestError('获取设置失败', err);
    } finally {
      if (mounted) setState(() => _loadingSettings = false);
    }
  }

  Future<void> _updateSettings() async {
    final raw = _settingsJsonController.text.trim();
    if (raw.isEmpty) {
      _showError('请输入设置 JSON');
      return;
    }
    setState(() => _loadingUpdateSettings = true);
    try {
      final data = jsonDecode(raw);
      final response = await _runAuthorized(
        () => _apiClient!.post(
          '/system-notifications/update_notification_settings/',
          data: data,
        ),
      );
      setState(() => _settingsResult = _asMap(response.data));
    } catch (err) {
      _showRequestError('更新失败', err);
    } finally {
      if (mounted) setState(() => _loadingUpdateSettings = false);
    }
  }

  Future<void> _loadStatus() async {
    setState(() => _loadingStatus = true);
    try {
      final response = await _runAuthorized(
        () => _apiClient!.get('/system-notifications/system_status/'),
      );
      setState(() => _statusResult = _asMap(response.data));
    } catch (err) {
      _showRequestError('获取状态失败', err);
    } finally {
      if (mounted) setState(() => _loadingStatus = false);
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

  List<int> _parseIds(String raw) {
    return raw
        .split(RegExp(r'[,\n]'))
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .toList();
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
    final spacing = LayoutTokens.sectionSpacing(context);
    return SingleChildScrollView(
      padding: LayoutTokens.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSendNotificationCard(),
          SizedBox(height: spacing),
          _buildAdvancedSection(),
        ],
      ),
    );
  }

  Widget _buildSendNotificationCard() {
    final isUrgent = _notificationType == 'urgent';
    final titleController = isUrgent
        ? _alertTitleController
        : _announcementTitleController;
    final contentController = isUrgent
        ? _alertContentController
        : _announcementContentController;
    final recipientsController = isUrgent
        ? _alertRecipientsController
        : _announcementRecipientsController;
    final loading = isUrgent ? _loadingAlert : _loadingAnnouncement;
    final result = isUrgent ? _alertResult : _announcementResult;
    return NotificationAdminSection(
      title: '发送通知',
      child: NotificationFieldList(
        children: [
          AppSelect<String>(
            key: ValueKey<String>('notification-type-$_notificationType'),
            value: _notificationType,
            decoration: const InputDecoration(labelText: '通知类型'),
            options: const [
              AppDropdownOption(value: 'announcement', label: '系统公告'),
              AppDropdownOption(value: 'urgent', label: '紧急通知'),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _notificationType = value);
            },
          ),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: '标题',
              prefixIcon: Icon(Icons.campaign_outlined),
            ),
          ),
          TextField(
            controller: contentController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '内容',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),
          TextField(
            controller: recipientsController,
            decoration: const InputDecoration(
              labelText: '指定接收人 ID（可选）',
              hintText: '多个 ID 用逗号或换行分隔；留空发送给默认范围',
              prefixIcon: Icon(Icons.people_outline),
            ),
          ),
          if (!isUrgent)
            TextField(
              controller: _announcementExpiresController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '有效天数（可选）',
                prefixIcon: Icon(Icons.timer_outlined),
              ),
            ),
          SwitchListTile(
            value: isUrgent ? _alertOnlyStaff : _announcementOnlyStaff,
            onChanged: (value) => setState(
              () => isUrgent
                  ? _alertOnlyStaff = value
                  : _announcementOnlyStaff = value,
            ),
            title: const Text('仅发送给员工'),
            contentPadding: EdgeInsets.zero,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: loading
                  ? null
                  : (isUrgent ? _sendUrgentAlert : _createAnnouncement),
              icon: NotificationLoadingIcon(
                loading: loading,
                icon: isUrgent
                    ? Icons.priority_high_outlined
                    : Icons.send_outlined,
              ),
              label: Text(loading ? '发送中' : '发送通知'),
            ),
          ),
          if (result != null) NotificationResultPanel(result: result),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection() {
    return NotificationAdminSection(
      title: '高级设置',
      trailing: TextButton.icon(
        onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
        icon: Icon(_showAdvanced ? Icons.expand_less : Icons.expand_more),
        label: Text(_showAdvanced ? '收起' : '展开'),
      ),
      child: _showAdvanced
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSettingsCard(),
                const SizedBox(height: SpacingTokens.lg),
                _buildStatusCard(),
              ],
            )
          : Text(
              '全局通道、保留策略和系统状态属于低频配置，展开后查看和维护。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
    );
  }

  Widget _buildSettingsCard() {
    return NotificationAdminSection(
      title: '通知系统设置',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _settingsJsonController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: '设置 JSON',
              prefixIcon: Icon(Icons.tune_outlined),
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Wrap(
            spacing: SpacingTokens.sm,
            runSpacing: SpacingTokens.sm,
            children: [
              OutlinedButton.icon(
                onPressed: _loadingSettings ? null : _loadSettings,
                icon: NotificationLoadingIcon(
                  loading: _loadingSettings,
                  icon: Icons.refresh,
                ),
                label: Text(_loadingSettings ? '获取中' : '获取设置'),
              ),
              FilledButton.icon(
                onPressed: _loadingUpdateSettings ? null : _updateSettings,
                icon: NotificationLoadingIcon(
                  loading: _loadingUpdateSettings,
                  icon: Icons.save_outlined,
                ),
                label: Text(_loadingUpdateSettings ? '保存中' : '保存设置'),
              ),
            ],
          ),
          if (_settingsResult != null) ...[
            const SizedBox(height: SpacingTokens.sm),
            NotificationResultPanel(result: _settingsResult!),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return NotificationAdminSection(
      title: '系统状态',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _loadingStatus ? null : _loadStatus,
              icon: NotificationLoadingIcon(
                loading: _loadingStatus,
                icon: Icons.monitor_heart_outlined,
              ),
              label: Text(_loadingStatus ? '获取中' : '获取状态'),
            ),
          ),
          if (_statusResult != null) ...[
            const SizedBox(height: SpacingTokens.sm),
            NotificationResultPanel(result: _statusResult!),
          ],
        ],
      ),
    );
  }
}
