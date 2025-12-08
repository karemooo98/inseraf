import 'package:flutter/foundation.dart';

import '../entities/user_summary.dart';
import '../repositories/report_repository.dart';

class GetAllUsersSummaryReportUseCase {
  GetAllUsersSummaryReportUseCase(this._repository);

  final ReportRepository _repository;

  Future<List<UserSummary>> call({
    required DateTime from,
    required DateTime to,
  }) {
    if (kDebugMode) {
      debugPrint('=== GetAllUsersSummaryReportUseCase.call ===');
      debugPrint('Calling repository.getAllUsersSummary');
    }
    return _repository.getAllUsersSummary(from: from, to: to);
  }
}
