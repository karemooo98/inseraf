import '../repositories/team_repository.dart';

class DeleteTeamUseCase {
  DeleteTeamUseCase(this._repository);

  final TeamRepository _repository;

  Future<void> call(int teamId) => _repository.deleteTeam(teamId);
}

