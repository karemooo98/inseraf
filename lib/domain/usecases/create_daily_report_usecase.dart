import '../entities/daily_report.dart';
import '../repositories/daily_report_repository.dart';

class CreateDailyReportUseCase {
  CreateDailyReportUseCase(this._repository);

  final DailyReportRepository _repository;

  Future<DailyReport> call({
    required String date,
    required String description,
    required double hoursWorked,
    String? achievements,
    String? challenges,
    String? notes,
  }) =>
      _repository.createDailyReport(
        date: date,
        description: description,
        hoursWorked: hoursWorked,
        achievements: achievements,
        challenges: challenges,
        notes: notes,
      );
}

