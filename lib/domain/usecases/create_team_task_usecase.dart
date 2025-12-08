import '../entities/team_task.dart';
import '../repositories/team_repository.dart';

class CreateTeamTaskUseCase {
  CreateTeamTaskUseCase(this._repository);

  final TeamRepository _repository;

  Future<TeamTask> call({
    required int teamId,
    required int assignedToUserId,
    required String title,
    String? description,
    String? dueDate,
  }) =>
      _repository.createTask(
        teamId: teamId,
        assignedToUserId: assignedToUserId,
        title: title,
        description: description,
        dueDate: dueDate,
      );
}

