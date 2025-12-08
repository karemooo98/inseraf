import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/shift.dart';
import '../../domain/entities/shift_user.dart';
import 'shift_user_model.dart';

part 'shift_model.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  createToJson: false,
)
class ShiftModel extends Shift {
  ShiftModel({
    required super.id,
    required super.name,
    required super.startTime,
    required super.endTime,
    required super.isActive,
    super.gracePeriodMinutes,
    super.description,
    List<ShiftUserModel>? users,
    super.createdAt,
    super.updatedAt,
  }) : super(users: users?.cast<ShiftUser>() ?? <ShiftUser>[]);

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);
}
