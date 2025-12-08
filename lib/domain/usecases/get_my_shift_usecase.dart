import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

class GetMyShiftUseCase {
  GetMyShiftUseCase(this._repository);

  final ShiftRepository _repository;

  Future<Shift?> call() => _repository.getMyShift();
}

