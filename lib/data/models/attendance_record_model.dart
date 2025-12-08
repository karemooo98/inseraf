import '../../domain/entities/attendance_record.dart';

class AttendanceRecordModel extends AttendanceRecord {
  const AttendanceRecordModel({
    required super.userId,
    required super.userName,
    required super.date,
    super.id,
    super.userEmail,
    super.userEmployeeNumber,
    super.firstCheckIn,
    super.lastCheckOut,
    super.totalHours,
    super.workedHours,
    super.missingHours,
    super.overtimeHours,
    super.overtimeAmountIqd,
    super.status,
    super.isLocked,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      userId: (json['user_id'] as num).toInt(),
      userName: json['user_name'] as String,
      date: json['date'] as String,
      id: (json['id'] as num?)?.toInt(),
      userEmail: json['user_email'] as String?,
      userEmployeeNumber: json['user_employee_number']?.toString(),
      firstCheckIn: json['first_check_in'] as String?,
      lastCheckOut: json['last_check_out'] as String?,
      totalHours: (json['total_hours'] as num?)?.toDouble(),
      workedHours: (json['worked_hours'] as num?)?.toDouble(),
      missingHours: (json['missing_hours'] as num?)?.toDouble(),
      overtimeHours: (json['overtime_hours'] as num?)?.toDouble(),
      overtimeAmountIqd: (json['overtime_amount_iqd'] as num?)?.toInt(),
      status: json['status'] as String?,
      isLocked: json['is_locked'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_id': userId,
        'user_name': userName,
        'user_email': userEmail,
        'user_employee_number': userEmployeeNumber,
        'date': date,
        'first_check_in': firstCheckIn,
        'last_check_out': lastCheckOut,
        'total_hours': totalHours,
        'worked_hours': workedHours,
        'missing_hours': missingHours,
        'overtime_hours': overtimeHours,
        'overtime_amount_iqd': overtimeAmountIqd,
        'status': status,
        'is_locked': isLocked,
      };
}




