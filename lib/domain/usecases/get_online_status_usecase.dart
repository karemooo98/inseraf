import '../entities/online_attendance_status.dart';
import '../repositories/attendance_repository.dart';

class GetOnlineStatusUseCase {
  GetOnlineStatusUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<OnlineAttendanceStatus> call() => _repository.getOnlineStatus();
}

