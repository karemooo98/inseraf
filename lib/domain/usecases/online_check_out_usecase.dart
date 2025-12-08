import '../repositories/attendance_repository.dart';

class OnlineCheckOutUseCase {
  OnlineCheckOutUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<void> call() => _repository.onlineCheckOut();
}

