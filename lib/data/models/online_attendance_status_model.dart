import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/online_attendance_status.dart';

part 'online_attendance_status_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OnlineAttendanceStatusModel extends OnlineAttendanceStatus {
  const OnlineAttendanceStatusModel({
    required super.date,
    super.checkInTime,
    super.checkOutTime,
    super.totalHours,
    super.isLocked,
    super.canCheckIn,
    super.canCheckOut,
    super.currentIraqTime,
    super.message,
  });

  factory OnlineAttendanceStatusModel.fromJson(Map<String, dynamic> json) =>
      _$OnlineAttendanceStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineAttendanceStatusModelToJson(this);
}

