import '../entities/daily_report.dart';
import '../repositories/daily_report_repository.dart';

class GetMyDailyReportsUseCase {
  GetMyDailyReportsUseCase(this._repository);

  final DailyReportRepository _repository;

  Future<List<DailyReport>> call({String? date}) =>
      _repository.getMyDailyReports(date: date);
}

