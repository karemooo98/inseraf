import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/standalone_task.dart';

part 'standalone_task_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StandaloneTaskModel extends StandaloneTask {
  const StandaloneTaskModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.date,
    required super.reportedHours,
    required super.status,
    super.description,
    super.approvedHours,
    super.createdAt,
    super.updatedAt,
  });

  factory StandaloneTaskModel.fromJson(Map<String, dynamic> json) =>
      _$StandaloneTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$StandaloneTaskModelToJson(this);
}

