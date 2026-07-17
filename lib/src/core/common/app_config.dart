import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class AppConfig {
  AppConfig._();

  static String activeProfile = 'dev';
  static String apiBaseUrl = '';
  static int connectTimeoutMs = 10000;
  static int receiveTimeoutMs = 15000;
  static int transferTimeoutMs = 120000;

  static Future<void> init() async {
    const profileOverride = String.fromEnvironment('APP_PROFILE');
    const baseUrlOverride = String.fromEnvironment('APP_API_BASE_URL');
    final baseConfig = await _loadYamlAsset('config/application.yaml');
    activeProfile = profileOverride.trim().isNotEmpty
        ? profileOverride.trim()
        : (_readString(baseConfig, ['app', 'profiles', 'active']) ?? 'dev');
    final profileConfig = await _loadYamlAsset(
      'config/application-$activeProfile.yaml',
    );

    apiBaseUrl = baseUrlOverride.trim().isNotEmpty
        ? baseUrlOverride.trim()
        : (_readString(profileConfig, ['app', 'api', 'baseUrl']) ??
              _readString(baseConfig, ['app', 'api', 'baseUrl']) ??
              '');
    connectTimeoutMs =
        _readInt(baseConfig, ['app', 'api', 'connectTimeout']) ??
        connectTimeoutMs;
    receiveTimeoutMs =
        _readInt(baseConfig, ['app', 'api', 'receiveTimeout']) ??
        receiveTimeoutMs;
    transferTimeoutMs =
        _readInt(baseConfig, ['app', 'api', 'transferTimeout']) ??
        transferTimeoutMs;

    if (apiBaseUrl.trim().isEmpty) {
      throw StateError(
        '未配置接口地址，请检查 APP_API_BASE_URL 或 config/application-*.yaml',
      );
    }

    if (activeProfile == 'prod') {
      final uri = Uri.tryParse(apiBaseUrl);
      final host = uri?.host.toLowerCase() ?? '';
      if (host == '127.0.0.1' || host == 'localhost' || host == '0.0.0.0') {
        throw StateError('生产环境不能使用本地接口地址: $apiBaseUrl');
      }
    }
  }

  static Future<Map<String, dynamic>> _loadYamlAsset(String path) async {
    try {
      final content = await rootBundle.loadString(path);
      final yaml = loadYaml(content);
      if (yaml is YamlMap) {
        return _yamlMapToMap(yaml);
      }
    } catch (_) {
      // Ignore missing configs; fall back to defaults.
    }
    return <String, dynamic>{};
  }

  static Map<String, dynamic> _yamlMapToMap(YamlMap yamlMap) {
    final Map<String, dynamic> result = <String, dynamic>{};
    for (final entry in yamlMap.entries) {
      final key = entry.key.toString();
      final value = entry.value;
      if (value is YamlMap) {
        result[key] = _yamlMapToMap(value);
      } else {
        result[key] = value;
      }
    }
    return result;
  }

  static String? _readString(Map<String, dynamic> map, List<String> path) {
    dynamic current = map;
    for (final segment in path) {
      if (current is Map<String, dynamic>) {
        current = current[segment];
      } else {
        return null;
      }
    }
    return current?.toString();
  }

  static int? _readInt(Map<String, dynamic> map, List<String> path) {
    final value = _readString(map, path);
    if (value == null) {
      return null;
    }
    return int.tryParse(value);
  }
}
