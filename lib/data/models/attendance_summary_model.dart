import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/attendance_summary.dart';

part 'attendance_summary_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceSummaryModel extends AttendanceSummary {
  const AttendanceSummaryModel({
    required super.totalUsers,
    required super.present,
    required super.absent,
    required super.missingCheckout,
    required super.onTime,
    required super.leftEarly,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceSummaryModelToJson(this);
}




