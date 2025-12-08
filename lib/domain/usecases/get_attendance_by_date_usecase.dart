import '../entities/attendance_record.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceByDateUseCase {
  GetAttendanceByDateUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<List<AttendanceRecord>> call(DateTime date) => _repository.getAttendanceByDate(date);
}




