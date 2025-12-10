import '../../domain/entities/attendance_record.dart';

class AttendanceRecordModel extends AttendanceRecord {
  const AttendanceRecordModel({
    required super.userId,
    required super.userName,
    required super.date,
    super.id,
    super.userEmail,
    super.userEmployeeNumber,
    super.firstCheckIn,
    super.lastCheckOut,
    super.totalHours,
    super.workedHours,
    super.missingHours,
    super.overtimeHours,
    super.overtimeAmountIqd,
    super.status,
    super.isLocked,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely extract String values
    String? _safeString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      return value.toString();
    }
    
    // Helper to safely extract num values
    num? _safeNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      if (value is String) return num.tryParse(value);
      return null;
    }
    
    // Helper to safely extract bool values
    bool? _safeBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return null;
    }
    
    return AttendanceRecordModel(
      userId: _safeNum(json['user_id'])?.toInt() ?? 0,
      userName: _safeString(json['user_name']) ?? '',
      date: _safeString(json['date']) ?? '',
      id: _safeNum(json['id'])?.toInt(),
      userEmail: _safeString(json['user_email']),
      userEmployeeNumber: _safeString(json['user_employee_number']),
      firstCheckIn: _safeString(json['first_check_in']),
      lastCheckOut: _safeString(json['last_check_out']),
      totalHours: _safeNum(json['total_hours'])?.toDouble(),
      workedHours: _safeNum(json['worked_hours'])?.toDouble(),
      missingHours: _safeNum(json['missing_hours'])?.toDouble(),
      overtimeHours: _safeNum(json['overtime_hours'])?.toDouble(),
      overtimeAmountIqd: _safeNum(json['overtime_amount_iqd'])?.toInt(),
      status: _safeString(json['status']),
      isLocked: _safeBool(json['is_locked']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_id': userId,
        'user_name': userName,
        'user_email': userEmail,
        'user_employee_number': userEmployeeNumber,
        'date': date,
        'first_check_in': firstCheckIn,
        'last_check_out': lastCheckOut,
        'total_hours': totalHours,
        'worked_hours': workedHours,
        'missing_hours': missingHours,
        'overtime_hours': overtimeHours,
        'overtime_amount_iqd': overtimeAmountIqd,
        'status': status,
        'is_locked': isLocked,
      };
}




