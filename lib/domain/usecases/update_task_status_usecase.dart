import '../entities/team_task.dart';
import '../repositories/team_repository.dart';

class UpdateTaskStatusUseCase {
  UpdateTaskStatusUseCase(this._repository);

  final TeamRepository _repository;

  Future<TeamTask> call({
    required int taskId,
    required String status,
  }) =>
      _repository.updateTaskStatus(
        taskId: taskId,
        status: status,
      );
}

