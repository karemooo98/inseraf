import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_request.dart';

part 'user_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserRequestModel extends UserRequest {
  const UserRequestModel({
    required super.id,
    required super.type,
    required super.reason,
    required super.status,
    super.userId,
    super.userName,
    super.userEmail,
    super.startDate,
    super.endDate,
    super.totalDays,
    super.leaveType,
    super.date,
    super.checkIn,
    super.checkOut,
    super.approvedBy,
    super.approvedAt,
    super.approveNote,
  });

  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    // Handle nested user object if user_name/user_email are not present
    final Map<String, dynamic> modifiedJson = Map<String, dynamic>.from(json);
    
    if (json['user_name'] == null && json['user'] != null) {
      final Map<String, dynamic> user = json['user'] as Map<String, dynamic>;
      modifiedJson['user_name'] = user['name'] as String?;
      modifiedJson['user_email'] = user['email'] as String?;
    }
    
    return _$UserRequestModelFromJson(modifiedJson);
  }

  Map<String, dynamic> toJson() => _$UserRequestModelToJson(this);
}




