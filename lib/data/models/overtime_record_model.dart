import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/overtime_record.dart';

part 'overtime_record_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OvertimeRecordModel extends OvertimeRecord {
  const OvertimeRecordModel({
    required super.id,
    required super.date,
    required super.hours,
    required super.status,
    required super.employeeId,
    super.description,
    super.employeeName,
    super.employeeNumber,
    super.managerId,
    super.managerName,
    super.createdAt,
  });

  factory OvertimeRecordModel.fromJson(Map<String, dynamic> json) {
    // Handle employee_number conversion (can be int or string from API)
    final dynamic employeeNumber = json['employee_number'];
    final String? employeeNumberString = employeeNumber?.toString();
    
    // Create a modified json map with employee_number as string
    final Map<String, dynamic> modifiedJson = Map<String, dynamic>.from(json);
    if (employeeNumber != null) {
      modifiedJson['employee_number'] = employeeNumberString;
    }
    
    return _$OvertimeRecordModelFromJson(modifiedJson);
  }

  Map<String, dynamic> toJson() => _$OvertimeRecordModelToJson(this);
}

