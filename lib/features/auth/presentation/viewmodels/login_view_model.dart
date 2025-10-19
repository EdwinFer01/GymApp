import '../../../../core/viewmodels/base_view_model.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthUser? _currentUser;
  String? _errorMessage;

  AuthUser? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    setBusy(true);
    _errorMessage = null;

    try {
      final user = await _authRepository.login(email, password);
      if (user == null) {
        _errorMessage = 'Credenciales invalidas';
        return false;
      }
      _currentUser = user;
      return true;
    } catch (error) {
      _errorMessage = 'Error al iniciar sesion: $error';
      return false;
    } finally {
      setBusy(false);
    }
  }
}
