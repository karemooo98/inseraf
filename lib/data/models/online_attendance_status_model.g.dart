// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_attendance_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlineAttendanceStatusModel _$OnlineAttendanceStatusModelFromJson(
  Map<String, dynamic> json,
) => OnlineAttendanceStatusModel(
  date: json['date'] as String,
  checkInTime: json['check_in_time'] as String?,
  checkOutTime: json['check_out_time'] as String?,
  totalHours: (json['total_hours'] as num?)?.toDouble(),
  isLocked: json['is_locked'] as bool?,
  canCheckIn: json['can_check_in'] as bool?,
  canCheckOut: json['can_check_out'] as bool?,
  currentIraqTime: json['current_iraq_time'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$OnlineAttendanceStatusModelToJson(
  OnlineAttendanceStatusModel instance,
) => <String, dynamic>{
  'date': instance.date,
  'check_in_time': instance.checkInTime,
  'check_out_time': instance.checkOutTime,
  'total_hours': instance.totalHours,
  'is_locked': instance.isLocked,
  'can_check_in': instance.canCheckIn,
  'can_check_out': instance.canCheckOut,
  'current_iraq_time': instance.currentIraqTime,
  'message': instance.message,
};
