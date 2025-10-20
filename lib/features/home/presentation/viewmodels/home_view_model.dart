import '../../../../core/viewmodels/base_view_model.dart';
import '../../../auth/domain/entities/auth_user.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({required AuthUser user})
      : _user = user,
        _currentIndex = _defaultIndexFor(user.role);

  AuthUser _user;

  AuthUser get user => _user;

  int _currentIndex;

  int get currentIndex => _currentIndex;

  void onTabSelected(int index, int totalTabs) {
    if (index >= totalTabs) return;
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }

  static int _defaultIndexFor(AuthRole role) {
    switch (role) {
      case AuthRole.admin:
      case AuthRole.coach:
        return 1;
      case AuthRole.client:
        return 2;
    }
  }

  void updateUser(AuthUser user) {
    if (_user == user) return;
    final hasRoleChanged = _user.role != user.role;
    _user = user;
    if (hasRoleChanged) {
      _currentIndex = _defaultIndexFor(user.role);
    }
    notifyListeners();
  }
}
