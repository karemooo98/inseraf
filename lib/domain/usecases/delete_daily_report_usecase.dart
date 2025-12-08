import '../repositories/daily_report_repository.dart';

class DeleteDailyReportUseCase {
  DeleteDailyReportUseCase(this._repository);

  final DailyReportRepository _repository;

  Future<void> call(int reportId) => _repository.deleteDailyReport(reportId);
}

