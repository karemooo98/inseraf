import '../entities/overtime_record.dart';
import '../repositories/overtime_repository.dart';

class GetAllOvertimeUseCase {
  GetAllOvertimeUseCase(this._repository);

  final OvertimeRepository _repository;

  Future<List<OvertimeRecord>> call() => _repository.getAllOvertime();
}

