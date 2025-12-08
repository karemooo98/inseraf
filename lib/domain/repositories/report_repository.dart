import '../entities/user_summary.dart';

abstract class ReportRepository {
  Future<List<UserSummary>> getAllUsersSummary({
    required DateTime from,
    required DateTime to,
  });
  Future<Map<String, dynamic>> getUserReport({
    required int userId,
    DateTime? from,
    DateTime? to,
  });
}
