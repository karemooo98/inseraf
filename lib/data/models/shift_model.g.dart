// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => ShiftModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  isActive: json['is_active'] as bool,
  gracePeriodMinutes: (json['grace_period_minutes'] as num?)?.toInt(),
  description: json['description'] as String?,
  users: (json['users'] as List<dynamic>?)
      ?.map((e) => ShiftUserModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);
