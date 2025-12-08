import 'package:get/get.dart';

import '../../domain/entities/team.dart';
import '../../domain/usecases/add_team_member_usecase.dart';
import '../../domain/usecases/create_team_task_usecase.dart';
import '../../domain/usecases/create_team_usecase.dart';
import '../../domain/usecases/delete_team_usecase.dart';
import '../../domain/usecases/get_all_teams_usecase.dart';
import '../../domain/usecases/get_team_by_id_usecase.dart';
import '../../domain/usecases/remove_team_member_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';

class TeamController extends GetxController {
  TeamController({
    required GetAllTeamsUseCase getAllTeamsUseCase,
    required GetTeamByIdUseCase getTeamByIdUseCase,
    required CreateTeamUseCase createTeamUseCase,
    required DeleteTeamUseCase deleteTeamUseCase,
    required AddTeamMemberUseCase addTeamMemberUseCase,
    required RemoveTeamMemberUseCase removeTeamMemberUseCase,
    required CreateTeamTaskUseCase createTeamTaskUseCase,
    required UpdateTaskStatusUseCase updateTaskStatusUseCase,
  })  : _getAllTeamsUseCase = getAllTeamsUseCase,
        _getTeamByIdUseCase = getTeamByIdUseCase,
        _createTeamUseCase = createTeamUseCase,
        _deleteTeamUseCase = deleteTeamUseCase,
        _addTeamMemberUseCase = addTeamMemberUseCase,
        _removeTeamMemberUseCase = removeTeamMemberUseCase,
        _createTeamTaskUseCase = createTeamTaskUseCase,
        _updateTaskStatusUseCase = updateTaskStatusUseCase;

  final GetAllTeamsUseCase _getAllTeamsUseCase;
  final GetTeamByIdUseCase _getTeamByIdUseCase;
  final CreateTeamUseCase _createTeamUseCase;
  final DeleteTeamUseCase _deleteTeamUseCase;
  final AddTeamMemberUseCase _addTeamMemberUseCase;
  final RemoveTeamMemberUseCase _removeTeamMemberUseCase;
  final CreateTeamTaskUseCase _createTeamTaskUseCase;
  final UpdateTaskStatusUseCase _updateTaskStatusUseCase;

  final RxList<Team> teams = <Team>[].obs;
  final Rx<Team?> selectedTeam = Rx<Team?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isCreatingTeam = false.obs;
  final RxBool isCreatingTask = false.obs;
  final RxBool isUpdatingTask = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTeams();
  }

  Future<void> loadTeams() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final List<Team> result = await _getAllTeamsUseCase();
      teams.value = result;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTeamById(int teamId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final Team team = await _getTeamByIdUseCase(teamId);
      selectedTeam.value = team;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTeam(String name) async {
    try {
      isCreatingTeam.value = true;
      errorMessage.value = '';
      final Team team = await _createTeamUseCase(name);
      teams.add(team);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isCreatingTeam.value = false;
    }
  }

  Future<bool> deleteTeam(int teamId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _deleteTeamUseCase(teamId);
      teams.removeWhere((Team team) => team.id == teamId);
      if (selectedTeam.value?.id == teamId) {
        selectedTeam.value = null;
      }
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addMember({
    required int teamId,
    required int userId,
    required String teamRole,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _addTeamMemberUseCase(
        teamId: teamId,
        userId: userId,
        teamRole: teamRole,
      );
      await loadTeamById(teamId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> removeMember({
    required int teamId,
    required int userId,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _removeTeamMemberUseCase(
        teamId: teamId,
        userId: userId,
      );
      await loadTeamById(teamId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTask({
    required int teamId,
    required int assignedToUserId,
    required String title,
    String? description,
    String? dueDate,
  }) async {
    try {
      isCreatingTask.value = true;
      errorMessage.value = '';
      await _createTeamTaskUseCase(
        teamId: teamId,
        assignedToUserId: assignedToUserId,
        title: title,
        description: description,
        dueDate: dueDate,
      );
      await loadTeamById(teamId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isCreatingTask.value = false;
    }
  }

  Future<bool> updateTaskStatus({
    required int taskId,
    required String status,
  }) async {
    try {
      isUpdatingTask.value = true;
      errorMessage.value = '';
      await _updateTaskStatusUseCase(
        taskId: taskId,
        status: status,
      );
      if (selectedTeam.value != null) {
        await loadTeamById(selectedTeam.value!.id);
      }
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isUpdatingTask.value = false;
    }
  }
}

