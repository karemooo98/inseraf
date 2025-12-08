import '../entities/team.dart';
import '../repositories/team_repository.dart';

class CreateTeamUseCase {
  CreateTeamUseCase(this._repository);

  final TeamRepository _repository;

  Future<Team> call(String name) => _repository.createTeam(name);
}

