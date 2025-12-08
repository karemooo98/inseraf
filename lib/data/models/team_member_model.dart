import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/team_member.dart';

part 'team_member_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeamMemberModel extends TeamMember {
  const TeamMemberModel({
    required super.id,
    required super.name,
    required super.email,
    required super.employeeNumber,
    required super.teamRole,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> pivot = json['pivot'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return TeamMemberModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      employeeNumber: json['employee_number']?.toString() ?? '',
      teamRole: pivot['team_role'] as String? ?? 'employee',
    );
  }

  Map<String, dynamic> toJson() => _$TeamMemberModelToJson(this);
}

