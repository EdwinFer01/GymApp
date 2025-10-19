import '../entities/membership.dart';

abstract class MembershipRepository {
  const MembershipRepository();

  Future<int> saveMembership(Membership membership);
  Future<Membership?> getMembershipById(int id);
  Future<List<Membership>> getMembershipsByClient(int clientId);
  Future<int> deleteMembership(int id);
}
