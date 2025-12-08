import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/attendance_summary_overview.dart';

part 'attendance_summary_overview_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceSummaryOverviewModel extends AttendanceSummaryOverview {
  const AttendanceSummaryOverviewModel({
    required super.totalUsers,
    required super.present,
    required super.absent,
    required super.missingCheckout,
    required super.onTime,
    required super.leftEarly,
    required super.averageHours,
  });

  factory AttendanceSummaryOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSummaryOverviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceSummaryOverviewModelToJson(this);
}

