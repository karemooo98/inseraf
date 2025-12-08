// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_attendance_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyAttendanceRecordModel _$MyAttendanceRecordModelFromJson(
  Map<String, dynamic> json,
) => MyAttendanceRecordModel(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  date: json['date'] as String,
  dayName: json['day_name'] as String,
  firstCheckIn: json['first_check_in'] as String?,
  lastCheckOut: json['last_check_out'] as String?,
  totalHours: (json['total_hours'] as num?)?.toDouble(),
  workedHours: (json['worked_hours'] as num?)?.toDouble(),
  missingHours: (json['missing_hours'] as num?)?.toDouble(),
  overtimeHours: (json['overtime_hours'] as num?)?.toDouble(),
  overtimeAmountIqd: (json['overtime_amount_iqd'] as num?)?.toInt(),
  status: json['status'] as String?,
  isLate: json['is_late'] as bool?,
  lateMinutes: (json['late_minutes'] as num?)?.toInt(),
  isLocked: json['is_locked'] as bool?,
);

Map<String, dynamic> _$MyAttendanceRecordModelToJson(
  MyAttendanceRecordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'date': instance.date,
  'day_name': instance.dayName,
  'first_check_in': instance.firstCheckIn,
  'last_check_out': instance.lastCheckOut,
  'total_hours': instance.totalHours,
  'worked_hours': instance.workedHours,
  'missing_hours': instance.missingHours,
  'overtime_hours': instance.overtimeHours,
  'overtime_amount_iqd': instance.overtimeAmountIqd,
  'status': instance.status,
  'is_late': instance.isLate,
  'late_minutes': instance.lateMinutes,
  'is_locked': instance.isLocked,
};
