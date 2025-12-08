import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

class GetAllShiftsUseCase {
  GetAllShiftsUseCase(this._repository);

  final ShiftRepository _repository;

  Future<List<Shift>> call() => _repository.getAllShifts();
}
