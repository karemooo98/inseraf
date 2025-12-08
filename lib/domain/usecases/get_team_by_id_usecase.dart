import '../entities/team.dart';
import '../repositories/team_repository.dart';

class GetTeamByIdUseCase {
  GetTeamByIdUseCase(this._repository);

  final TeamRepository _repository;

  Future<Team> call(int teamId) => _repository.getTeamById(teamId);
}

