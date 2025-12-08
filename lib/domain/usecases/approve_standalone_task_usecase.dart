import '../entities/standalone_task.dart';
import '../repositories/standalone_task_repository.dart';

class ApproveStandaloneTaskUseCase {
  ApproveStandaloneTaskUseCase(this._repository);

  final StandaloneTaskRepository _repository;

  Future<StandaloneTask> call({
    required int taskId,
    required String status,
    double? approvedHours,
  }) =>
      _repository.approveTask(
        taskId: taskId,
        status: status,
        approvedHours: approvedHours,
      );
}

