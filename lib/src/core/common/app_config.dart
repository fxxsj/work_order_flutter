import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class AppConfig {
  AppConfig._();

  static String apiBaseUrl = '';
  static int connectTimeoutMs = 10000;
  static int receiveTimeoutMs = 3000;

  static Future<void> init() async {
    final baseConfig = await _loadYamlAsset('config/application.yaml');
    final activeProfile = _readString(baseConfig, ['app', 'profiles', 'active']) ?? 'dev';
    final profileConfig = await _loadYamlAsset('config/application-$activeProfile.yaml');

    apiBaseUrl = _readString(profileConfig, ['app', 'api', 'baseUrl']) ??
        _readString(baseConfig, ['app', 'api', 'baseUrl']) ??
        '';
    connectTimeoutMs = _readInt(baseConfig, ['app', 'api', 'connectTimeout']) ?? connectTimeoutMs;
    receiveTimeoutMs = _readInt(baseConfig, ['app', 'api', 'receiveTimeout']) ?? receiveTimeoutMs;
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
