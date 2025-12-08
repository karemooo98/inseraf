// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRequestModel _$UserRequestModelFromJson(Map<String, dynamic> json) =>
    UserRequestModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String,
      userId: (json['user_id'] as num?)?.toInt(),
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      totalDays: (json['total_days'] as num?)?.toInt(),
      leaveType: json['leave_type'] as String?,
      date: json['date'] as String?,
      checkIn: json['check_in'] as String?,
      checkOut: json['check_out'] as String?,
      approvedBy: (json['approved_by'] as num?)?.toInt(),
      approvedAt: json['approved_at'] as String?,
      approveNote: json['approve_note'] as String?,
    );

Map<String, dynamic> _$UserRequestModelToJson(UserRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'user_email': instance.userEmail,
      'type': instance.type,
      'reason': instance.reason,
      'status': instance.status,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'total_days': instance.totalDays,
      'leave_type': instance.leaveType,
      'date': instance.date,
      'check_in': instance.checkIn,
      'check_out': instance.checkOut,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt,
      'approve_note': instance.approveNote,
    };
