import 'package:work_order_app/common/http_client.dart';
import 'package:work_order_app/models/api_response.dart';

class AuthApi {
  static Future<ApiResponse> login(data) async {
    return HttpClient.post('/auth/login/', data: data);
  }

  static Future<ApiResponse> logout() async {
    return HttpClient.post('/auth/logout/');
  }

  static Future<ApiResponse> getCurrentUser() async {
    return HttpClient.get('/auth/user/');
  }
}
