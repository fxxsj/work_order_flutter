import 'package:work_order_app/common/http_client.dart';
import 'package:work_order_app/models/api_response.dart';

class UserApi {
  static Future<ApiResponse> register(data) async {
    return HttpClient.post('/user/register', data: data);
  }

  static Future<ApiResponse> login(data) async {
    return HttpClient.post('/user/login', data: data);
  }

  static Future<ApiResponse> loginByFace(data) async {
    return HttpClient.post('/user/loginByFace', data: data);
  }
}
