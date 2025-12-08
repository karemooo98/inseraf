import '../repositories/shift_repository.dart';

class DeleteShiftUseCase {
  DeleteShiftUseCase(this._repository);

  final ShiftRepository _repository;

  Future<void> call(int shiftId) => _repository.deleteShift(shiftId);
}
