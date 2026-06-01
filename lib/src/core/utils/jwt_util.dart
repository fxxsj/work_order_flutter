import 'dart:convert';

class JwtUtil {
  const JwtUtil._();

  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }
      final payloadBase64 = base64Url.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(payloadBase64));
      final decoded = jsonDecode(payloadString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return null;
  }

  static bool isExpired(String token, {int leewaySeconds = 30}) {
    final payload = decodePayload(token);
    if (payload == null) {
      return true;
    }
    final exp = payload['exp'];
    if (exp is! int) {
      return true;
    }
    final expTime = DateTime.fromMillisecondsSinceEpoch(
      exp * 1000,
      isUtc: true,
    );
    final now = DateTime.now().toUtc();
    return now.isAfter(expTime.add(Duration(seconds: leewaySeconds)));
  }

  static bool isExpiring(String token, {int leewaySeconds = 30}) {
    final payload = decodePayload(token);
    if (payload == null) {
      return false;
    }
    final exp = payload['exp'];
    if (exp is! int) {
      return false;
    }
    final expTime = DateTime.fromMillisecondsSinceEpoch(
      exp * 1000,
      isUtc: true,
    );
    final now = DateTime.now().toUtc();
    return now.isAfter(expTime.subtract(Duration(seconds: leewaySeconds)));
  }
}
