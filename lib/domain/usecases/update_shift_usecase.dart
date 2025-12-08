import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

class UpdateShiftUseCase {
  UpdateShiftUseCase(this._repository);

  final ShiftRepository _repository;

  Future<Shift> call({
    required int shiftId,
    String? name,
    String? startTime,
    String? endTime,
    int? gracePeriodMinutes,
    String? description,
    bool? isActive,
  }) => _repository.updateShift(
    shiftId: shiftId,
    name: name,
    startTime: startTime,
    endTime: endTime,
    gracePeriodMinutes: gracePeriodMinutes,
    description: description,
    isActive: isActive,
  );
}
