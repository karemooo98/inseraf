import '../entities/attendance_record.dart';
import '../repositories/attendance_repository.dart';

class GetMyAttendanceUseCase {
  GetMyAttendanceUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<List<AttendanceRecord>> call({int? limit}) => _repository.getMyAttendance(limit: limit);
}




