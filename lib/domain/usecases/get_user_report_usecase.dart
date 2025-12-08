import '../repositories/report_repository.dart';

class GetUserReportUseCase {
  GetUserReportUseCase(this._repository);

  final ReportRepository _repository;

  Future<Map<String, dynamic>> call({
    required int userId,
    DateTime? from,
    DateTime? to,
  }) => _repository.getUserReport(userId: userId, from: from, to: to);
}
