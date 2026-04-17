class AppMetadata {
  AppMetadata._();

  static const String defaultDisplayName = '新西彩订单管理';
  static const String displayName = String.fromEnvironment(
    'APP_DISPLAY_NAME',
    defaultValue: defaultDisplayName,
  );
}
