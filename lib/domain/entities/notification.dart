import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  const Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.relatedId,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final String type; // 'task_assigned', 'request_approved', 'request_rejected', 'day_off_approved', 'leave_approved', 'overtime_added'
  final String title;
  final String message;
  final int? relatedId;
  final bool isRead;
  final String createdAt;
  final String? updatedAt;

  @override
  List<Object?> get props => <Object?>[
        id,
        userId,
        type,
        title,
        message,
        relatedId,
        isRead,
        createdAt,
        updatedAt,
      ];
}

