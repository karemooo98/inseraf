import '../entities/user_summary.dart';
import '../repositories/attendance_repository.dart';

class GetAllUsersSummaryUseCase {
  GetAllUsersSummaryUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<List<UserSummary>> call({
    DateTime? from,
    DateTime? to,
  }) =>
      _repository.getAllUsersSummary(from: from, to: to);
}




