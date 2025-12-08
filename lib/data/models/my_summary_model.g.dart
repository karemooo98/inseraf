// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MySummaryModel _$MySummaryModelFromJson(Map<String, dynamic> json) =>
    MySummaryModel(
      attendance: (json['attendance'] as List<dynamic>)
          .map(
            (e) => MyAttendanceRecordModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      missingDaysCount: (json['missing_days_count'] as num).toInt(),
      absentDays: (json['absent_days'] as List<dynamic>)
          .map((e) => AbsentDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      weekendDays: (json['weekend_days'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      statistics: json['statistics'] as Map<String, dynamic>?,
      overtime: (json['overtime'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
