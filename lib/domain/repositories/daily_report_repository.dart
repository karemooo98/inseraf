import '../entities/daily_report.dart';

abstract class DailyReportRepository {
  Future<List<DailyReport>> getMyDailyReports({String? date});
  Future<List<DailyReport>> getAllDailyReports({
    int? userId,
    String? startDate,
    String? endDate,
  });
  Future<DailyReport> createDailyReport({
    required String date,
    required String description,
    required double hoursWorked,
    String? achievements,
    String? challenges,
    String? notes,
  });
  Future<DailyReport> updateDailyReport({
    required int reportId,
    String? description,
    double? hoursWorked,
    String? achievements,
    String? challenges,
    String? notes,
  });
  Future<void> deleteDailyReport(int reportId);
}

