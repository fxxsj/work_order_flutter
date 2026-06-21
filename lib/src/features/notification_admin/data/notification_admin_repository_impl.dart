import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/notification_admin/domain/notification_admin_repository.dart';

class NotificationAdminRepositoryImpl implements NotificationAdminRepository {
  NotificationAdminRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<Map<String, dynamic>> getTemplates() async {
    final response = await _client.get('/notification-templates/get_templates/');
    return _asMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> updateTemplate({
    required String templateName,
    required String title,
    required String message,
    required List<String> variables,
    required bool isActive,
  }) async {
    final response = await _client.post(
      '/notification-templates/update_template/',
      data: {
        'template_name': templateName,
        'title': title,
        'message': message,
        'variables': variables,
        'is_active': isActive,
      },
    );
    return _asMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> previewTemplate({
    required String templateName,
    required Map<String, dynamic> variables,
  }) async {
    final response = await _client.post(
      '/notification-templates/preview_template/',
      data: {
        'template_name': templateName,
        'variables': variables,
      },
    );
    return _asMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> createAnnouncement({
    required String title,
    required String content,
    required bool onlyStaff,
    List<int>? recipientIds,
    int? expiresInDays,
  }) async {
    final data = <String, dynamic>{
      'title': title,
      'content': content,
      'only_staff': onlyStaff,
    };
    if (recipientIds != null && recipientIds.isNotEmpty) {
      data['recipient_ids'] = recipientIds;
    }
    if (expiresInDays != null) {
      data['expires_in_days'] = expiresInDays;
    }
    final response = await _client.post(
      '/system-notifications/create_announcement/',
      data: data,
    );
    return _asMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> sendUrgentAlert({
    required String title,
    required String content,
    required bool onlyStaff,
    List<int>? recipientIds,
  }) async {
    final data = <String, dynamic>{
      'title': title,
      'content': content,
      'only_staff': onlyStaff,
    };
    if (recipientIds != null && recipientIds.isNotEmpty) {
      data['recipient_ids'] = recipientIds;
    }
    final response = await _client.post(
      '/system-notifications/send_urgent_alert/',
      data: data,
    );
    return _asMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> getSystemSettings() async {
    final response = await _client.get(
      '/system-notifications/notification_settings/',
    );
    return _asMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> updateSystemSettings(
    Map<String, dynamic> data,
  ) async {
    final response = await _client.post(
      '/system-notifications/update_notification_settings/',
      data: data,
    );
    return _asMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> getSystemStatus() async {
    final response = await _client.get('/system-notifications/system_status/');
    return _asMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> getUserSettings() async {
    final response = await _client.get(
      '/user-notification-settings/get_settings/',
    );
    return _asMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> updateUserSettings(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/user-notification-settings/update_settings/',
      data: payload,
    );
    return _asMap(response.data);
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
}
