import '../../../../core/viewmodels/base_view_model.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class RegistrationViewModel extends BaseViewModel {
  RegistrationViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthUser? _createdUser;
  String? _errorMessage;

  AuthUser? get createdUser => _createdUser;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required AuthRole role,
  }) async {
    setBusy(true);
    _errorMessage = null;

    try {
      final exists = await _authRepository.emailExists(email);
      if (exists) {
        _errorMessage = 'El correo ya esta registrado';
        return false;
      }

      _createdUser = await _authRepository.register(
        email: email,
        password: password,
        displayName: name,
        role: role,
      );
      return true;
    } catch (error) {
      _errorMessage = 'Error al registrar: $error';
      return false;
    } finally {
      setBusy(false);
    }
  }
}
