import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/absent_day.dart';
import '../../domain/entities/my_attendance_record.dart';
import '../../domain/entities/my_summary.dart';
import 'absent_day_model.dart';
import 'my_attendance_record_model.dart';

part 'my_summary_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, createToJson: false)
class MySummaryModel extends MySummary {
  MySummaryModel({
    required List<MyAttendanceRecordModel> attendance,
    required super.missingDaysCount,
    required List<AbsentDayModel> absentDays,
    required super.weekendDays,
    super.statistics,
    super.overtime,
    super.tasks,
  }) : super(
          attendance: attendance.cast<MyAttendanceRecord>(),
          absentDays: absentDays.cast<AbsentDay>(),
        );

  factory MySummaryModel.fromJson(Map<String, dynamic> json) => _$MySummaryModelFromJson(json);
}

