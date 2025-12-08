// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceSummaryModel _$AttendanceSummaryModelFromJson(
  Map<String, dynamic> json,
) => AttendanceSummaryModel(
  totalUsers: (json['total_users'] as num).toInt(),
  present: (json['present'] as num).toInt(),
  absent: (json['absent'] as num).toInt(),
  missingCheckout: (json['missing_checkout'] as num).toInt(),
  onTime: (json['on_time'] as num).toInt(),
  leftEarly: (json['left_early'] as num).toInt(),
);

Map<String, dynamic> _$AttendanceSummaryModelToJson(
  AttendanceSummaryModel instance,
) => <String, dynamic>{
  'total_users': instance.totalUsers,
  'present': instance.present,
  'absent': instance.absent,
  'missing_checkout': instance.missingCheckout,
  'on_time': instance.onTime,
  'left_early': instance.leftEarly,
};
