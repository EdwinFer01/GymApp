import '../../../../core/viewmodels/base_view_model.dart';
import '../../../auth/domain/entities/auth_user.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({required this.user});

  final AuthUser user;

  int _currentIndex = 1;

  int get currentIndex => _currentIndex;

  void onTabSelected(int index, int totalTabs) {
    if (index >= totalTabs) return;
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }
}
