import '../entities/team.dart';
import '../repositories/team_repository.dart';

class GetAllTeamsUseCase {
  GetAllTeamsUseCase(this._repository);

  final TeamRepository _repository;

  Future<List<Team>> call() => _repository.getAllTeams();
}

