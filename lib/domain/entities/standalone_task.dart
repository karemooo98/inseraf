import 'package:equatable/equatable.dart';

class StandaloneTask extends Equatable {
  const StandaloneTask({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.reportedHours,
    required this.status,
    this.description,
    this.approvedHours,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final String title;
  final String? description;
  final String date;
  final double reportedHours;
  final double? approvedHours;
  final String status; // 'pending', 'approved', 'rejected'
  final String? createdAt;
  final String? updatedAt;

  @override
  List<Object?> get props => <Object?>[
        id,
        userId,
        title,
        description,
        date,
        reportedHours,
        approvedHours,
        status,
        createdAt,
        updatedAt,
      ];
}

