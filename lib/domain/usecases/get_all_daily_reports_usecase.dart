import '../entities/daily_report.dart';
import '../repositories/daily_report_repository.dart';

class GetAllDailyReportsUseCase {
  GetAllDailyReportsUseCase(this._repository);

  final DailyReportRepository _repository;

  Future<List<DailyReport>> call({
    int? userId,
    String? startDate,
    String? endDate,
  }) =>
      _repository.getAllDailyReports(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
}

