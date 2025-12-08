import '../repositories/shift_repository.dart';

class RemoveUserFromShiftUseCase {
  RemoveUserFromShiftUseCase(this._repository);

  final ShiftRepository _repository;

  Future<void> call({required int shiftId, required int userId}) =>
      _repository.removeUserFromShift(shiftId: shiftId, userId: userId);
}
