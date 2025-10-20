import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? AuthLocalDataSource();

  final AuthLocalDataSource _localDataSource;

  @override
  Future<bool> emailExists(String email) {
    return _localDataSource.emailExists(email);
  }

  @override
  Future<AuthUser?> getUserById(int id) async {
    final user = await _localDataSource.getUserById(id);
    return user?.toEntity();
  }

  @override
  Future<AuthUser?> login(String email, String password) async {
    final user = await _localDataSource.login(email: email, password: password);
    return user?.toEntity();
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String displayName,
    required AuthRole role,
  }) async {
    final userId = await _localDataSource.registerUser(
      email: email,
      password: password,
      displayName: displayName,
      role: role.name,
      photoUrl: null,
    );
    final user = await _localDataSource.getUserById(userId);
    if (user == null) {
      throw StateError('User registration failed');
    }
    return user.toEntity();
  }

  @override
  Future<void> updatePassword({
    required int userId,
    required String newPassword,
  }) {
    return _localDataSource.updatePassword(
      userId: userId,
      newPassword: newPassword,
    );
  }
}
