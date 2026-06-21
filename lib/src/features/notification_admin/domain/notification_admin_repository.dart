abstract class NotificationAdminRepository {
  Future<Map<String, dynamic>> getTemplates();

  Future<Map<String, dynamic>> updateTemplate({
    required String templateName,
    required String title,
    required String message,
    required List<String> variables,
    required bool isActive,
  });

  Future<Map<String, dynamic>> previewTemplate({
    required String templateName,
    required Map<String, dynamic> variables,
  });

  Future<Map<String, dynamic>> createAnnouncement({
    required String title,
    required String content,
    required bool onlyStaff,
    List<int>? recipientIds,
    int? expiresInDays,
  });

  Future<Map<String, dynamic>> sendUrgentAlert({
    required String title,
    required String content,
    required bool onlyStaff,
    List<int>? recipientIds,
  });

  Future<Map<String, dynamic>> getSystemSettings();

  Future<Map<String, dynamic>> updateSystemSettings(
    Map<String, dynamic> data,
  );

  Future<Map<String, dynamic>> getSystemStatus();

  Future<Map<String, dynamic>> getUserSettings();

  Future<Map<String, dynamic>> updateUserSettings(
    Map<String, dynamic> payload,
  );
}
