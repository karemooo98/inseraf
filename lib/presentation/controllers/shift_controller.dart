import 'package:get/get.dart';

import '../../domain/entities/shift.dart';
import '../../domain/usecases/assign_users_to_shift_usecase.dart';
import '../../domain/usecases/create_shift_usecase.dart';
import '../../domain/usecases/delete_shift_usecase.dart';
import '../../domain/usecases/get_all_shifts_usecase.dart';
import '../../domain/usecases/get_my_shift_usecase.dart';
import '../../domain/usecases/get_shift_by_id_usecase.dart';
import '../../domain/usecases/remove_user_from_shift_usecase.dart';
import '../../domain/usecases/update_shift_usecase.dart';

class ShiftController extends GetxController {
  ShiftController({
    required GetAllShiftsUseCase getAllShiftsUseCase,
    required GetShiftByIdUseCase getShiftByIdUseCase,
    required GetMyShiftUseCase getMyShiftUseCase,
    required CreateShiftUseCase createShiftUseCase,
    required UpdateShiftUseCase updateShiftUseCase,
    required DeleteShiftUseCase deleteShiftUseCase,
    required AssignUsersToShiftUseCase assignUsersToShiftUseCase,
    required RemoveUserFromShiftUseCase removeUserFromShiftUseCase,
  })  : _getAllShiftsUseCase = getAllShiftsUseCase,
        _getShiftByIdUseCase = getShiftByIdUseCase,
        _getMyShiftUseCase = getMyShiftUseCase,
        _createShiftUseCase = createShiftUseCase,
        _updateShiftUseCase = updateShiftUseCase,
        _deleteShiftUseCase = deleteShiftUseCase,
        _assignUsersToShiftUseCase = assignUsersToShiftUseCase,
        _removeUserFromShiftUseCase = removeUserFromShiftUseCase;

  final GetAllShiftsUseCase _getAllShiftsUseCase;
  final GetShiftByIdUseCase _getShiftByIdUseCase;
  final GetMyShiftUseCase _getMyShiftUseCase;
  final CreateShiftUseCase _createShiftUseCase;
  final UpdateShiftUseCase _updateShiftUseCase;
  final DeleteShiftUseCase _deleteShiftUseCase;
  final AssignUsersToShiftUseCase _assignUsersToShiftUseCase;
  final RemoveUserFromShiftUseCase _removeUserFromShiftUseCase;

  final RxList<Shift> shifts = <Shift>[].obs;
  final Rx<Shift?> selectedShift = Rx<Shift?>(null);
  final Rx<Shift?> myShift = Rx<Shift?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isCreatingShift = false.obs;
  final RxBool isUpdatingShift = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadShifts();
  }

  Future<void> loadShifts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final List<Shift> result = await _getAllShiftsUseCase();
      shifts.value = result;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadShiftById(int shiftId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final Shift shift = await _getShiftByIdUseCase(shiftId);
      selectedShift.value = shift;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createShift({
    required String name,
    required String startTime,
    required String endTime,
    int? gracePeriodMinutes,
    String? description,
  }) async {
    try {
      isCreatingShift.value = true;
      errorMessage.value = '';
      final Shift shift = await _createShiftUseCase(
        name: name,
        startTime: startTime,
        endTime: endTime,
        gracePeriodMinutes: gracePeriodMinutes,
        description: description,
      );
      shifts.add(shift);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isCreatingShift.value = false;
    }
  }

  Future<bool> updateShift({
    required int shiftId,
    String? name,
    String? startTime,
    String? endTime,
    int? gracePeriodMinutes,
    String? description,
    bool? isActive,
  }) async {
    try {
      isUpdatingShift.value = true;
      errorMessage.value = '';
      final Shift shift = await _updateShiftUseCase(
        shiftId: shiftId,
        name: name,
        startTime: startTime,
        endTime: endTime,
        gracePeriodMinutes: gracePeriodMinutes,
        description: description,
        isActive: isActive,
      );
      final int index = shifts.indexWhere((Shift s) => s.id == shiftId);
      if (index != -1) {
        shifts[index] = shift;
      }
      if (selectedShift.value?.id == shiftId) {
        selectedShift.value = shift;
      }
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isUpdatingShift.value = false;
    }
  }

  Future<bool> deleteShift(int shiftId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _deleteShiftUseCase(shiftId);
      shifts.removeWhere((Shift shift) => shift.id == shiftId);
      if (selectedShift.value?.id == shiftId) {
        selectedShift.value = null;
      }
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> assignUsers({
    required int shiftId,
    required List<int> userIds,
    String? effectiveFrom,
    String? effectiveTo,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _assignUsersToShiftUseCase(
        shiftId: shiftId,
        userIds: userIds,
        effectiveFrom: effectiveFrom,
        effectiveTo: effectiveTo,
      );
      await loadShiftById(shiftId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> removeUser({
    required int shiftId,
    required int userId,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _removeUserFromShiftUseCase(
        shiftId: shiftId,
        userId: userId,
      );
      await loadShiftById(shiftId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMyShift() async {
    try {
      final Shift? shift = await _getMyShiftUseCase();
      myShift.value = shift;
    } catch (e) {
      // Silently fail - user may not have a shift assigned
      myShift.value = null;
    }
  }
}

