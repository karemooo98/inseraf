import '../repositories/team_repository.dart';

class AddTeamMemberUseCase {
  AddTeamMemberUseCase(this._repository);

  final TeamRepository _repository;

  Future<void> call({
    required int teamId,
    required int userId,
    required String teamRole,
  }) =>
      _repository.addMemberToTeam(
        teamId: teamId,
        userId: userId,
        teamRole: teamRole,
      );
}

