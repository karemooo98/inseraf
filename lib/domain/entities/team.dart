import 'package:equatable/equatable.dart';

import 'team_member.dart';
import 'team_task.dart';

class Team extends Equatable {
  const Team({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.members,
    this.tasks = const <TeamTask>[],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final int createdBy;
  final List<TeamMember> members;
  final List<TeamTask> tasks;
  final String? createdAt;
  final String? updatedAt;

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        createdBy,
        members,
        tasks,
        createdAt,
        updatedAt,
      ];
}

