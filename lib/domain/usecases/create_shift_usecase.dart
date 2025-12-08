import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

class CreateShiftUseCase {
  CreateShiftUseCase(this._repository);

  final ShiftRepository _repository;

  Future<Shift> call({
    required String name,
    required String startTime,
    required String endTime,
    int? gracePeriodMinutes,
    String? description,
  }) => _repository.createShift(
    name: name,
    startTime: startTime,
    endTime: endTime,
    gracePeriodMinutes: gracePeriodMinutes,
    description: description,
  );
}
