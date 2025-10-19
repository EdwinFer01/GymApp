import 'package:flutter/foundation.dart';

/// Provides a thin wrapper around [ChangeNotifier] so all view models share
/// the same contract and helpers in a single place.
abstract class BaseViewModel extends ChangeNotifier {
  bool _isBusy = false;

  bool get isBusy => _isBusy;

  void setBusy(bool value) {
    if (_isBusy == value) return;
    _isBusy = value;
    notifyListeners();
  }
}
