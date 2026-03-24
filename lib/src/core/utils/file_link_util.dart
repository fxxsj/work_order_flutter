import 'package:work_order_app/src/core/common/app_config.dart';
import 'package:work_order_app/src/core/utils/utils.dart';

class FileLinkUtil {
  FileLinkUtil._();

  static String? resolveUrl(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) return null;

    final parsed = Uri.tryParse(value);
    if (parsed != null && parsed.hasScheme) {
      return parsed.toString();
    }

    final apiUri = Uri.tryParse(AppConfig.apiBaseUrl);
    if (apiUri == null || !apiUri.hasScheme || apiUri.host.isEmpty) {
      return value;
    }

    final origin = Uri(
      scheme: apiUri.scheme,
      host: apiUri.host,
      port: apiUri.hasPort ? apiUri.port : null,
    );
    return origin.resolveUri(Uri.parse(value)).toString();
  }

  static Future<void> open(String? raw) async {
    final url = resolveUrl(raw);
    if (url == null) {
      throw '文件地址无效';
    }
    await Utils.launchURL(url);
  }
}
