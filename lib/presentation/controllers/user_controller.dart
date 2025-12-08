import 'package:get/get.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../domain/usecases/get_all_users_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';

class UserController extends GetxController {
  UserController({
    required GetAllUsersUseCase getAllUsersUseCase,
    required GetUserByIdUseCase getUserByIdUseCase,
    required CreateUserUseCase createUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
  })  : _getAllUsersUseCase = getAllUsersUseCase,
        _getUserByIdUseCase = getUserByIdUseCase,
        _createUserUseCase = createUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _deleteUserUseCase = deleteUserUseCase;

  final GetAllUsersUseCase _getAllUsersUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  final RxList<User> users = <User>[].obs;
  final Rx<User?> selectedUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;
  String? selectedRoleFilter;

  @override
  void onInit() {
    super.onInit();
    loadAllUsers();
  }

  Future<void> loadAllUsers({String? role}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedRoleFilter = role;
      final List<User> result = await _getAllUsersUseCase(role: role);
      users.value = result;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserById(int userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final User user = await _getUserByIdUseCase(userId);
      selectedUser.value = user;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    int? employeeNumber,
    bool? isActive,
  }) async {
    try {
      isCreating.value = true;
      errorMessage.value = '';
      final User user = await _createUserUseCase(
        name: name,
        email: email,
        password: password,
        role: role,
        employeeNumber: employeeNumber,
        isActive: isActive,
      );
      users.insert(0, user);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  Future<bool> updateUser({
    required int userId,
    String? name,
    String? email,
    String? password,
    String? role,
    int? employeeNumber,
    bool? isActive,
  }) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';
      final User user = await _updateUserUseCase(
        userId: userId,
        name: name,
        email: email,
        password: password,
        role: role,
        employeeNumber: employeeNumber,
        isActive: isActive,
      );
      final int index = users.indexWhere((User u) => u.id == userId);
      if (index != -1) {
        users[index] = user;
      }
      if (selectedUser.value?.id == userId) {
        selectedUser.value = user;
      }
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> deleteUser(int userId) async {
    try {
      isDeleting.value = true;
      errorMessage.value = '';
      await _deleteUserUseCase(userId);
      users.removeWhere((User u) => u.id == userId);
      if (selectedUser.value?.id == userId) {
        selectedUser.value = null;
      }
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }
}

