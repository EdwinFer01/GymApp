import '../entities/auth_user.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<AuthUser?> login(String email, String password);
  Future<AuthUser> register({
    required String email,
    required String password,
    required String displayName,
    required AuthRole role,
  });
  Future<bool> emailExists(String email);
  Future<AuthUser?> getUserById(int id);
  Future<void> updatePassword({
    required int userId,
    required String newPassword,
  });
}
