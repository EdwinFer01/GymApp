import 'package:flutter/foundation.dart';

import '../../../../core/viewmodels/base_view_model.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../data/repositories/membership_repository_impl.dart';
import '../../domain/entities/membership.dart';
import '../../domain/repositories/membership_repository.dart';

class ClientMembershipViewModel extends BaseViewModel {
  ClientMembershipViewModel({
    required AuthUser user,
    MembershipRepository? membershipRepository,
  }) : _user = user,
       clientId = user.id,
       _membershipRepository =
           membershipRepository ?? MembershipRepositoryImpl();

  final AuthUser _user;
  final int clientId;
  final MembershipRepository _membershipRepository;

  Membership? _current;
  List<Membership> _memberships = <Membership>[];
  String? _lastError;

  AuthUser get user => _user;
  Membership? get currentMembership => _current;
  List<Membership> get memberships =>
      List<Membership>.unmodifiable(_memberships);
  String? get lastError => _lastError;

  Future<void> load() async {
    setBusy(true);
    _lastError = null;
    try {
      await _refreshCurrent();
    } catch (error, stackTrace) {
      debugPrint('Error loading memberships: $error');
      debugPrintStack(stackTrace: stackTrace);
      _memberships = <Membership>[];
      _current = null;
      _lastError = 'No pudimos cargar tu membresia. Intenta nuevamente.';
      notifyListeners();
    } finally {
      setBusy(false);
    }
  }

  Future<bool> saveMembership(Membership membership) async {
    setBusy(true);
    _lastError = null;
    try {
      final toSave = membership.copyWith(clientId: clientId);
      final resolvedStatus = _resolveStatus(toSave);
      final adjusted = toSave.copyWith(status: resolvedStatus);
      await _membershipRepository.saveMembership(adjusted);
      await _refreshCurrent();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Error saving membership: $error');
      debugPrintStack(stackTrace: stackTrace);
      _lastError = 'No pudimos guardar los cambios. Intenta nuevamente.';
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<void> _refreshCurrent() async {
    final items = await _membershipRepository.getMembershipsByClient(clientId);
    final normalized = items
        .map(
          (membership) =>
              membership.copyWith(status: _resolveStatus(membership)),
        )
        .toList(growable: false);
    _memberships = normalized;
    _current = normalized.isEmpty ? null : normalized.first;
    notifyListeners();
  }

  MembershipStatus _resolveStatus(Membership membership) {
    final now = DateTime.now();
    if (membership.endDate.isBefore(now)) {
      return MembershipStatus.expired;
    }
    if (membership.startDate.isAfter(now)) {
      return MembershipStatus.pending;
    }
    return MembershipStatus.active;
  }
}
