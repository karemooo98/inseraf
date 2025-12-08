import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

class GetShiftByIdUseCase {
  GetShiftByIdUseCase(this._repository);

  final ShiftRepository _repository;

  Future<Shift> call(int shiftId) => _repository.getShiftById(shiftId);
}
