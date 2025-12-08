import '../entities/standalone_task.dart';

abstract class StandaloneTaskRepository {
  Future<StandaloneTask> createTask({
    required String title,
    required String date,
    required double reportedHours,
    String? description,
  });
  Future<List<StandaloneTask>> getMyTasks();
  Future<List<StandaloneTask>> getAllTasks({String? status});
  Future<StandaloneTask> approveTask({
    required int taskId,
    required String status,
    double? approvedHours,
  });
}

