import '../repositories/attendance_repository.dart';

class OnlineCheckInUseCase {
  OnlineCheckInUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<void> call() => _repository.onlineCheckIn();
}

