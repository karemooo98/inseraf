import '../entities/standalone_task.dart';
import '../repositories/standalone_task_repository.dart';

class GetAllStandaloneTasksUseCase {
  GetAllStandaloneTasksUseCase(this._repository);

  final StandaloneTaskRepository _repository;

  Future<List<StandaloneTask>> call({String? status}) =>
      _repository.getAllTasks(status: status);
}

