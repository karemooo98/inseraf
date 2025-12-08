import '../../domain/entities/standalone_task.dart';
import '../../domain/repositories/standalone_task_repository.dart';
import '../datasources/remote_api_service.dart';
import '../models/standalone_task_model.dart';

class StandaloneTaskRepositoryImpl implements StandaloneTaskRepository {
  StandaloneTaskRepositoryImpl(this._api);

  final RemoteApiService _api;

  @override
  Future<StandaloneTask> createTask({
    required String title,
    required String date,
    required double reportedHours,
    String? description,
  }) async {
    final Map<String, dynamic> response = await _api.createTask(
      title: title,
      date: date,
      reportedHours: reportedHours,
      description: description,
    );
    final Map<String, dynamic> data = response.containsKey('data')
        ? Map<String, dynamic>.from(response['data'] as Map)
        : response;
    return StandaloneTaskModel.fromJson(data);
  }

  @override
  Future<List<StandaloneTask>> getMyTasks() async {
    final dynamic response = await _api.getMyTasks();
    final List<Map<String, dynamic>> parsed = _asList(response);
    return parsed
        .map((Map<String, dynamic> item) => StandaloneTaskModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<StandaloneTask>> getAllTasks({String? status}) async {
    final dynamic response = await _api.getAllTasks(status: status);
    final List<Map<String, dynamic>> parsed = _asList(response);
    return parsed
        .map((Map<String, dynamic> item) => StandaloneTaskModel.fromJson(item))
        .toList();
  }

  @override
  Future<StandaloneTask> approveTask({
    required int taskId,
    required String status,
    double? approvedHours,
  }) async {
    final Map<String, dynamic> response = await _api.approveTask(
      taskId: taskId,
      status: status,
      approvedHours: approvedHours,
    );
    final Map<String, dynamic> data = response.containsKey('data')
        ? Map<String, dynamic>.from(response['data'] as Map)
        : response;
    return StandaloneTaskModel.fromJson(data);
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    if (response is List) {
      return response.map((dynamic item) => Map<String, dynamic>.from(item as Map)).toList();
    }
    if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        return data.map((dynamic item) => Map<String, dynamic>.from(item as Map)).toList();
      }
    }
    return <Map<String, dynamic>>[];
  }
}

