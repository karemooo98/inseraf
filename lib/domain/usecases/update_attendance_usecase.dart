import '../entities/attendance_record.dart';
import '../repositories/attendance_repository.dart';

class UpdateAttendanceUseCase {
  UpdateAttendanceUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<AttendanceRecord> call({
    required int? recordId,
    required int userId,
    required String date,
    required String status,
    String? checkIn,
    String? checkOut,
    String? hoursAdjustmentType,
    double? hoursAdjustment,
    String? reason,
  }) =>
      _repository.updateAttendance(
        recordId: recordId,
        userId: userId,
        date: date,
        status: status,
        checkIn: checkIn,
        checkOut: checkOut,
        hoursAdjustmentType: hoursAdjustmentType,
        hoursAdjustment: hoursAdjustment,
        reason: reason,
      );
}

