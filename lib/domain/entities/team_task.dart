import 'package:equatable/equatable.dart';

enum TaskStatus {
  pending,
  inProgress,
  completed,
  reviewed,
}

class TeamTask extends Equatable {
  const TeamTask({
    required this.id,
    required this.teamId,
    required this.assignedToUserId,
    required this.assignedByUserId,
    required this.title,
    required this.status,
    this.description,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int teamId;
  final int assignedToUserId;
  final int assignedByUserId;
  final String title;
  final String? description;
  final String? dueDate;
  final String status; // 'pending', 'in_progress', 'completed', 'reviewed'
  final String? createdAt;
  final String? updatedAt;

  TaskStatus get statusEnum {
    switch (status.toLowerCase()) {
      case 'pending':
        return TaskStatus.pending;
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'reviewed':
        return TaskStatus.reviewed;
      default:
        return TaskStatus.pending;
    }
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        teamId,
        assignedToUserId,
        assignedByUserId,
        title,
        description,
        dueDate,
        status,
        createdAt,
        updatedAt,
      ];
}

