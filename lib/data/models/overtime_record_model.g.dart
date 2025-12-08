// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overtime_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OvertimeRecordModel _$OvertimeRecordModelFromJson(Map<String, dynamic> json) =>
    OvertimeRecordModel(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      hours: (json['hours'] as num).toDouble(),
      status: json['status'] as String,
      employeeId: (json['employee_id'] as num).toInt(),
      description: json['description'] as String?,
      employeeName: json['employee_name'] as String?,
      employeeNumber: json['employee_number'] as String?,
      managerId: (json['manager_id'] as num?)?.toInt(),
      managerName: json['manager_name'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$OvertimeRecordModelToJson(
  OvertimeRecordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'hours': instance.hours,
  'description': instance.description,
  'status': instance.status,
  'employee_id': instance.employeeId,
  'employee_name': instance.employeeName,
  'employee_number': instance.employeeNumber,
  'manager_id': instance.managerId,
  'manager_name': instance.managerName,
  'created_at': instance.createdAt,
};
