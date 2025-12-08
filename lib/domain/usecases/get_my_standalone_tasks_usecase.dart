import '../entities/standalone_task.dart';
import '../repositories/standalone_task_repository.dart';

class GetMyStandaloneTasksUseCase {
  GetMyStandaloneTasksUseCase(this._repository);

  final StandaloneTaskRepository _repository;

  Future<List<StandaloneTask>> call() => _repository.getMyTasks();
}

