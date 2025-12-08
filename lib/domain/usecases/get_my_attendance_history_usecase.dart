import '../entities/my_attendance_record.dart';
import '../repositories/attendance_repository.dart';

class GetMyAttendanceHistoryUseCase {
  GetMyAttendanceHistoryUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<List<MyAttendanceRecord>> call({int limit = 30}) =>
      _repository.getMyAttendanceHistory(limit: limit);
}
