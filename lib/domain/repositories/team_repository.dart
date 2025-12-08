import '../entities/team.dart';
import '../entities/team_task.dart';

abstract class TeamRepository {
  Future<List<Team>> getAllTeams();
  Future<Team> getTeamById(int teamId);
  Future<Team> createTeam(String name);
  Future<void> deleteTeam(int teamId);
  Future<void> addMemberToTeam({
    required int teamId,
    required int userId,
    required String teamRole,
  });
  Future<void> removeMemberFromTeam({
    required int teamId,
    required int userId,
  });
  Future<TeamTask> createTask({
    required int teamId,
    required int assignedToUserId,
    required String title,
    String? description,
    String? dueDate,
  });
  Future<TeamTask> updateTaskStatus({
    required int taskId,
    required String status,
  });
}

