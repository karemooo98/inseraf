// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSummaryModel _$UserSummaryModelFromJson(Map<String, dynamic> json) =>
    UserSummaryModel(
      userId: (json['user_id'] as num).toInt(),
      name: json['name'] as String,
      employeeNumber: json['employee_number'] as String?,
      totalWorkedHours: (json['total_worked_hours'] as num?)?.toDouble(),
      totalMissingHours: (json['total_missing_hours'] as num?)?.toDouble(),
      totalOvertimeHours: (json['total_overtime_hours'] as num?)?.toDouble(),
      effectiveMissingHours: (json['effective_missing_hours'] as num?)
          ?.toDouble(),
      effectiveOvertimeHours: (json['effective_overtime_hours'] as num?)
          ?.toDouble(),
      overtimeAmountIqd: (json['overtime_amount_iqd'] as num?)?.toInt(),
      absentDays: (json['absent_days'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserSummaryModelToJson(UserSummaryModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'employee_number': instance.employeeNumber,
      'total_worked_hours': instance.totalWorkedHours,
      'total_missing_hours': instance.totalMissingHours,
      'total_overtime_hours': instance.totalOvertimeHours,
      'effective_missing_hours': instance.effectiveMissingHours,
      'effective_overtime_hours': instance.effectiveOvertimeHours,
      'overtime_amount_iqd': instance.overtimeAmountIqd,
      'absent_days': instance.absentDays,
    };
