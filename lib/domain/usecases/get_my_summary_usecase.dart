import '../entities/attendance_summary_overview.dart';
import '../repositories/attendance_repository.dart';

class GetMySummaryUseCase {
  GetMySummaryUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<AttendanceSummaryOverview> call({DateTime? from, DateTime? to}) =>
      _repository.getMySummary(from: from, to: to);
}

