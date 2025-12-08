// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftUserModel _$ShiftUserModelFromJson(Map<String, dynamic> json) =>
    ShiftUserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      employeeNumber: json['employee_number'] as String,
      effectiveFrom: json['effective_from'] as String?,
      effectiveTo: json['effective_to'] as String?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$ShiftUserModelToJson(ShiftUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'employee_number': instance.employeeNumber,
      'effective_from': instance.effectiveFrom,
      'effective_to': instance.effectiveTo,
      'is_active': instance.isActive,
    };
