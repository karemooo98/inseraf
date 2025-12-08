// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamTaskModel _$TeamTaskModelFromJson(Map<String, dynamic> json) =>
    TeamTaskModel(
      id: (json['id'] as num).toInt(),
      teamId: (json['team_id'] as num).toInt(),
      assignedToUserId: (json['assigned_to_user_id'] as num).toInt(),
      assignedByUserId: (json['assigned_by_user_id'] as num).toInt(),
      title: json['title'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$TeamTaskModelToJson(TeamTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'team_id': instance.teamId,
      'assigned_to_user_id': instance.assignedToUserId,
      'assigned_by_user_id': instance.assignedByUserId,
      'title': instance.title,
      'description': instance.description,
      'due_date': instance.dueDate,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
