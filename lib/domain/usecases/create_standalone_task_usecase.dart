import '../entities/standalone_task.dart';
import '../repositories/standalone_task_repository.dart';

class CreateStandaloneTaskUseCase {
  CreateStandaloneTaskUseCase(this._repository);

  final StandaloneTaskRepository _repository;

  Future<StandaloneTask> call({
    required String title,
    required String date,
    required double reportedHours,
    String? description,
  }) =>
      _repository.createTask(
        title: title,
        date: date,
        reportedHours: reportedHours,
        description: description,
      );
}

