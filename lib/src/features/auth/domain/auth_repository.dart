import 'package:work_order_app/src/features/auth/domain/user.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  });

  Future<void> register(User user);

  Future<Map<String, dynamic>> fetchCurrentUser();

  Future<Map<String, dynamic>> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
  });

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
