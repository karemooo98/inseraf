import '../repositories/team_repository.dart';

class RemoveTeamMemberUseCase {
  RemoveTeamMemberUseCase(this._repository);

  final TeamRepository _repository;

  Future<void> call({
    required int teamId,
    required int userId,
  }) =>
      _repository.removeMemberFromTeam(
        teamId: teamId,
        userId: userId,
      );
}

