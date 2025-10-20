import 'package:flutter/foundation.dart';

/// Provides a thin wrapper around [ChangeNotifier] so all view models share
/// the same contract and helpers in a single place.
abstract class BaseViewModel extends ChangeNotifier {
  bool _isBusy = false;
  bool _disposed = false;

  bool get isBusy => _isBusy;
  @protected
  bool get isDisposed => _disposed;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void setBusy(bool value) {
    if (_isBusy == value || _disposed) return;
    _isBusy = value;
    notifyListeners();
  }

  void safeNotifyListeners() {
    if (_disposed) return;
    notifyListeners();
  }
}
