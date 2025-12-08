import '../entities/my_summary.dart';
import '../repositories/attendance_repository.dart';

class GetMyFullSummaryUseCase {
  GetMyFullSummaryUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<MySummary> call({DateTime? from, DateTime? to}) =>
      _repository.getMyFullSummary(from: from, to: to);
}
