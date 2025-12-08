// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standalone_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandaloneTaskModel _$StandaloneTaskModelFromJson(Map<String, dynamic> json) =>
    StandaloneTaskModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      title: json['title'] as String,
      date: json['date'] as String,
      reportedHours: (json['reported_hours'] as num).toDouble(),
      status: json['status'] as String,
      description: json['description'] as String?,
      approvedHours: (json['approved_hours'] as num?)?.toDouble(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$StandaloneTaskModelToJson(
  StandaloneTaskModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'title': instance.title,
  'description': instance.description,
  'date': instance.date,
  'reported_hours': instance.reportedHours,
  'approved_hours': instance.approvedHours,
  'status': instance.status,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
