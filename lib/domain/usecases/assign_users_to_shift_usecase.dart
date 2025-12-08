import '../repositories/shift_repository.dart';

class AssignUsersToShiftUseCase {
  AssignUsersToShiftUseCase(this._repository);

  final ShiftRepository _repository;

  Future<void> call({
    required int shiftId,
    required List<int> userIds,
    String? effectiveFrom,
    String? effectiveTo,
  }) => _repository.assignUsersToShift(
    shiftId: shiftId,
    userIds: userIds,
    effectiveFrom: effectiveFrom,
    effectiveTo: effectiveTo,
  );
}
