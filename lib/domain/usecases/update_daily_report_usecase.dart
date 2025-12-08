import '../entities/daily_report.dart';
import '../repositories/daily_report_repository.dart';

class UpdateDailyReportUseCase {
  UpdateDailyReportUseCase(this._repository);

  final DailyReportRepository _repository;

  Future<DailyReport> call({
    required int reportId,
    String? description,
    double? hoursWorked,
    String? achievements,
    String? challenges,
    String? notes,
  }) =>
      _repository.updateDailyReport(
        reportId: reportId,
        description: description,
        hoursWorked: hoursWorked,
        achievements: achievements,
        challenges: challenges,
        notes: notes,
      );
}

