import '../../domain/entities/team.dart';
import '../../domain/entities/team_task.dart';
import '../../domain/repositories/team_repository.dart';
import '../datasources/remote_api_service.dart';
import '../models/team_model.dart';
import '../models/team_task_model.dart';

class TeamRepositoryImpl implements TeamRepository {
  TeamRepositoryImpl(this._api);

  final RemoteApiService _api;

  @override
  Future<List<Team>> getAllTeams() async {
    final dynamic response = await _api.getAllTeams();
    final List<Map<String, dynamic>> parsed = _asList(response);
    return parsed.map((Map<String, dynamic> item) => TeamModel.fromJson(item)).toList();
  }

  @override
  Future<Team> getTeamById(int teamId) async {
    final Map<String, dynamic> response = await _api.getTeamById(teamId);
    final Map<String, dynamic> data = response['data'] as Map<String, dynamic>? ?? response;
    return TeamModel.fromJson(data);
  }

  @override
  Future<Team> createTeam(String name) async {
    final Map<String, dynamic> response = await _api.createTeam(name);
    final Map<String, dynamic> data = response['data'] as Map<String, dynamic>? ?? response;
    return TeamModel.fromJson(data);
  }

  @override
  Future<void> deleteTeam(int teamId) async {
    await _api.deleteTeam(teamId);
  }

  @override
  Future<void> addMemberToTeam({
    required int teamId,
    required int userId,
    required String teamRole,
  }) async {
    await _api.addMemberToTeam(teamId: teamId, userId: userId, teamRole: teamRole);
  }

  @override
  Future<void> removeMemberFromTeam({
    required int teamId,
    required int userId,
  }) async {
    await _api.removeMemberFromTeam(teamId: teamId, userId: userId);
  }

  @override
  Future<TeamTask> createTask({
    required int teamId,
    required int assignedToUserId,
    required String title,
    String? description,
    String? dueDate,
  }) async {
    final Map<String, dynamic> response = await _api.createTeamTask(
      teamId: teamId,
      assignedToUserId: assignedToUserId,
      title: title,
      description: description,
      dueDate: dueDate,
    );
    final Map<String, dynamic> data = response['data'] as Map<String, dynamic>? ?? response;
    return TeamTaskModel.fromJson(data);
  }

  @override
  Future<TeamTask> updateTaskStatus({
    required int taskId,
    required String status,
  }) async {
    final Map<String, dynamic> response = await _api.updateTaskStatus(
      taskId: taskId,
      status: status,
    );
    final Map<String, dynamic> data = response['data'] as Map<String, dynamic>? ?? response;
    return TeamTaskModel.fromJson(data);
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

