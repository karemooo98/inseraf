import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/shift_user.dart';

part 'shift_user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ShiftUserModel extends ShiftUser {
  const ShiftUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.employeeNumber,
    super.effectiveFrom,
    super.effectiveTo,
    super.isActive,
  });

  factory ShiftUserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> pivot =
        json['pivot'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return ShiftUserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      employeeNumber: json['employee_number']?.toString() ?? '',
      effectiveFrom: pivot['effective_from'] as String?,
      effectiveTo: pivot['effective_to'] as String?,
      isActive: pivot['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => _$ShiftUserModelToJson(this);
}
