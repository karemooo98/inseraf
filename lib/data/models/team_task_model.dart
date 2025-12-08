import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/team_task.dart';

part 'team_task_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeamTaskModel extends TeamTask {
  const TeamTaskModel({
    required super.id,
    required super.teamId,
    required super.assignedToUserId,
    required super.assignedByUserId,
    required super.title,
    required super.status,
    super.description,
    super.dueDate,
    super.createdAt,
    super.updatedAt,
  });

  factory TeamTaskModel.fromJson(Map<String, dynamic> json) => _$TeamTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamTaskModelToJson(this);
}

