// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) => TeamModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  createdBy: (json['created_by'] as num).toInt(),
  members: (json['members'] as List<dynamic>)
      .map((e) => TeamMemberModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  tasks: (json['tasks'] as List<dynamic>?)
      ?.map((e) => TeamTaskModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);
