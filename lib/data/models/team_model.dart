import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/team.dart';
import '../../domain/entities/team_task.dart';
import 'team_member_model.dart';
import 'team_task_model.dart';

part 'team_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, createToJson: false)
class TeamModel extends Team {
  TeamModel({
    required super.id,
    required super.name,
    required super.createdBy,
    required List<TeamMemberModel> members,
    List<TeamTaskModel>? tasks,
    super.createdAt,
    super.updatedAt,
  }) : super(
          members: members.cast(),
          tasks: tasks?.cast<TeamTask>() ?? <TeamTask>[],
        );

  factory TeamModel.fromJson(Map<String, dynamic> json) => _$TeamModelFromJson(json);
}

