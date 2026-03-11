import 'package:work_order_app/src/features/auth/data/auth_api.dart';
import 'package:work_order_app/src/features/auth/domain/auth_repository.dart';
import 'package:work_order_app/src/features/auth/domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authApi);

  final AuthApi _authApi;

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final result = await _authApi.login({
      'username': username,
      'password': password,
    });
    final responseData = result.data ?? <String, dynamic>{};
    return Map<String, dynamic>.from(responseData);
  }

  @override
  Future<void> register(User user) async {
    final payload = <String, dynamic>{
      'username': user.userName,
      'password': user.password,
    };
    await _authApi.register(payload);
  }

  @override
  Future<Map<String, dynamic>> fetchCurrentUser() async {
    final result = await _authApi.getCurrentUser();
    final responseData = result.data ?? <String, dynamic>{};
    return Map<String, dynamic>.from(responseData);
  }

  @override
  Future<Map<String, dynamic>> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    final result = await _authApi.updateProfile({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    });
    final responseData = result.data ?? <String, dynamic>{};
    return Map<String, dynamic>.from(responseData);
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _authApi.changePassword({
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    });
  }
}
