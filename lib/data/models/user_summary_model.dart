import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_summary.dart';

part 'user_summary_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserSummaryModel extends UserSummary {
  const UserSummaryModel({
    required super.userId,
    required super.name,
    super.employeeNumber,
    super.totalWorkedHours,
    super.totalMissingHours,
    super.totalOvertimeHours,
    super.effectiveMissingHours,
    super.effectiveOvertimeHours,
    super.overtimeAmountIqd,
    super.absentDays,
  });

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to num
    num? _safeToNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      if (value is List) return null; // If it's a list, treat as null
      if (value is String) {
        return num.tryParse(value);
      }
      return null;
    }
    
    // The API returns data in nested structure:
    // {
    //   "user": { "id": 3, "name": "...", "employee_number": 11 },
    //   "statistics": { "total_worked_hours": 11.11, ... },
    //   "absent_days": [...],
    //   ...
    // }
    
    // Extract user information
    final Map<String, dynamic>? user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : null;
    
    // Extract statistics
    final Map<String, dynamic>? statistics = json['statistics'] is Map
        ? Map<String, dynamic>.from(json['statistics'] as Map)
        : null;
    
    // Build a flat structure for the generated code
    final Map<String, dynamic> modifiedJson = <String, dynamic>{};
    
    // Extract user_id from nested user object or top-level
    final dynamic userIdValue = user?['id'] ?? json['user_id'];
    if (userIdValue == null || userIdValue is List) {
      modifiedJson['user_id'] = 0;
    } else if (userIdValue is num) {
      modifiedJson['user_id'] = userIdValue.toInt();
    } else {
      modifiedJson['user_id'] = int.tryParse(userIdValue.toString()) ?? 0;
    }
    
    // Extract name from nested user object or top-level
    final dynamic nameValue = user?['name'] ?? json['name'];
    if (nameValue == null || nameValue is List) {
      modifiedJson['name'] = '';
    } else {
      modifiedJson['name'] = nameValue.toString();
    }
    
    // Extract employee_number from nested user object or top-level
    final dynamic employeeNumberValue = user?['employee_number'] ?? json['employee_number'];
    if (employeeNumberValue != null && employeeNumberValue is! List) {
      modifiedJson['employee_number'] = employeeNumberValue.toString();
    }
    
    // Extract statistics fields
    if (statistics != null) {
      modifiedJson['total_worked_hours'] = _safeToNum(statistics['total_worked_hours']);
      modifiedJson['total_missing_hours'] = _safeToNum(statistics['total_missing_hours']);
      modifiedJson['total_overtime_hours'] = _safeToNum(statistics['total_overtime_hours']);
      modifiedJson['overtime_amount_iqd'] = _safeToNum(statistics['total_overtime_amount_iqd']);
      // Use absent_days_count from statistics if available
      modifiedJson['absent_days'] = _safeToNum(statistics['absent_days_count'])?.toInt();
    } else {
      // Fallback to top-level fields if statistics not available
      modifiedJson['total_worked_hours'] = _safeToNum(json['total_worked_hours']);
      modifiedJson['total_missing_hours'] = _safeToNum(json['total_missing_hours']);
      modifiedJson['total_overtime_hours'] = _safeToNum(json['total_overtime_hours']);
      modifiedJson['overtime_amount_iqd'] = _safeToNum(json['overtime_amount_iqd']);
    }
    
    // Handle absent_days - prefer statistics['absent_days_count'], otherwise count array or use top-level
    if (statistics == null || statistics['absent_days_count'] == null) {
      final dynamic absentDaysValue = json['absent_days'];
      if (absentDaysValue is List) {
        modifiedJson['absent_days'] = absentDaysValue.length;
      } else if (absentDaysValue != null) {
        modifiedJson['absent_days'] = _safeToNum(absentDaysValue)?.toInt();
      }
    }
    
    // Handle effective fields (may not be in statistics, check top-level)
    modifiedJson['effective_missing_hours'] = _safeToNum(json['effective_missing_hours']);
    modifiedJson['effective_overtime_hours'] = _safeToNum(json['effective_overtime_hours']);
    
    return _$UserSummaryModelFromJson(modifiedJson);
  }

  Map<String, dynamic> toJson() => _$UserSummaryModelToJson(this);
}




