import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';

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
        _settingsJsonController.text =
            const JsonEncoder.withIndent('  ').convert(data);
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
      if (err.statusCode == 401 && await (_apiClient?.refreshAccessToken() ?? Future.value(false))) {
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
          _buildAnnouncementCard(),
          SizedBox(height: spacing),
          _buildAlertCard(),
          SizedBox(height: spacing),
          _buildSettingsCard(),
          SizedBox(height: spacing),
          _buildStatusCard(),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('系统公告', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _announcementTitleController,
            decoration: const InputDecoration(
              hintText: '公告标题',
              prefixIcon: Icon(Icons.campaign_outlined),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _announcementContentController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '公告内容',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _announcementRecipientsController,
            decoration: const InputDecoration(
              hintText: '接收人ID（逗号分隔，可选）',
              prefixIcon: Icon(Icons.people_outline),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _announcementExpiresController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '有效天数（可选）',
              prefixIcon: Icon(Icons.timer_outlined),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          SwitchListTile(
            value: _announcementOnlyStaff,
            onChanged: (value) =>
                setState(() => _announcementOnlyStaff = value),
            title: const Text('仅发送给员工'),
            contentPadding: EdgeInsets.zero,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: _loadingAnnouncement ? null : _createAnnouncement,
              icon: _loadingAnnouncement
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_outlined, size: 18),
              label: Text(_loadingAnnouncement ? '发送中' : '发送公告'),
            ),
          ),
          if (_announcementResult != null) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            _buildResult(_announcementResult!),
          ],
        ],
      ),
    );
  }

  Widget _buildAlertCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('紧急警报', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _alertTitleController,
            decoration: const InputDecoration(
              hintText: '警报标题',
              prefixIcon: Icon(Icons.warning_amber_outlined),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _alertContentController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '警报内容',
              prefixIcon: Icon(Icons.report_outlined),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _alertRecipientsController,
            decoration: const InputDecoration(
              hintText: '接收人ID（逗号分隔，可选）',
              prefixIcon: Icon(Icons.people_outline),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          SwitchListTile(
            value: _alertOnlyStaff,
            onChanged: (value) => setState(() => _alertOnlyStaff = value),
            title: const Text('仅发送给员工'),
            contentPadding: EdgeInsets.zero,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: _loadingAlert ? null : _sendUrgentAlert,
              icon: _loadingAlert
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.flash_on_outlined, size: 18),
              label: Text(_loadingAlert ? '发送中' : '发送警报'),
            ),
          ),
          if (_alertResult != null) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            _buildResult(_alertResult!),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('通知系统设置', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: LayoutTokens.gapSm),
          TextField(
            controller: _settingsJsonController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: '设置 JSON',
              prefixIcon: Icon(Icons.tune_outlined),
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
            children: [
              OutlinedButton.icon(
                onPressed: _loadingSettings ? null : _loadSettings,
                icon: _loadingSettings
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 18),
                label: Text(_loadingSettings ? '获取中' : '获取设置'),
              ),
              FilledButton.icon(
                onPressed: _loadingUpdateSettings ? null : _updateSettings,
                icon: _loadingUpdateSettings
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined, size: 18),
                label: Text(_loadingUpdateSettings ? '保存中' : '保存设置'),
              ),
            ],
          ),
          if (_settingsResult != null) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            _buildResult(_settingsResult!),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('系统状态', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: LayoutTokens.gapSm),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _loadingStatus ? null : _loadStatus,
              icon: _loadingStatus
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.monitor_heart_outlined, size: 18),
              label: Text(_loadingStatus ? '获取中' : '获取状态'),
            ),
          ),
          if (_statusResult != null) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            _buildResult(_statusResult!),
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
      child:
          SelectableText(pretty, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
