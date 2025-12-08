import '../entities/shift.dart';

abstract class ShiftRepository {
  Future<List<Shift>> getAllShifts();
  Future<Shift> getShiftById(int shiftId);
  Future<Shift> createShift({
    required String name,
    required String startTime,
    required String endTime,
    int? gracePeriodMinutes,
    String? description,
  });
  Future<Shift> updateShift({
    required int shiftId,
    String? name,
    String? startTime,
    String? endTime,
    int? gracePeriodMinutes,
    String? description,
    bool? isActive,
  });
  Future<void> deleteShift(int shiftId);
  Future<void> assignUsersToShift({
    required int shiftId,
    required List<int> userIds,
    String? effectiveFrom,
    String? effectiveTo,
  });
  Future<void> removeUserFromShift({required int shiftId, required int userId});
  Future<Shift?> getMyShift();
}
