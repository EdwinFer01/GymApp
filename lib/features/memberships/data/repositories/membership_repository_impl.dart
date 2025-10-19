import '../../domain/entities/membership.dart';
import '../../domain/repositories/membership_repository.dart';
import '../datasources/membership_local_data_source.dart';
import '../models/membership_model.dart';

class MembershipRepositoryImpl implements MembershipRepository {
  MembershipRepositoryImpl({MembershipLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? MembershipLocalDataSource();

  final MembershipLocalDataSource _localDataSource;

  @override
  Future<int> deleteMembership(int id) {
    return _localDataSource.deleteMembership(id);
  }

  @override
  Future<Membership?> getMembershipById(int id) {
    return _localDataSource.getMembershipById(id);
  }

  @override
  Future<List<Membership>> getMembershipsByClient(int clientId) {
    return _localDataSource.getMembershipsByClient(clientId);
  }

  @override
  Future<int> saveMembership(Membership membership) {
    return _localDataSource.upsertMembership(
      MembershipModel.fromEntity(membership),
    );
  }
}
