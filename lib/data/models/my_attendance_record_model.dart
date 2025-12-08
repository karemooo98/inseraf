import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_attendance_record.dart';

part 'my_attendance_record_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MyAttendanceRecordModel extends MyAttendanceRecord {
  const MyAttendanceRecordModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.dayName,
    super.firstCheckIn,
    super.lastCheckOut,
    super.totalHours,
    super.workedHours,
    super.missingHours,
    super.overtimeHours,
    super.overtimeAmountIqd,
    super.status,
    super.isLate,
    super.lateMinutes,
    super.isLocked,
  });

  factory MyAttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$MyAttendanceRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyAttendanceRecordModelToJson(this);
}

