import 'package:equatable/equatable.dart';

class DailyReport extends Equatable {
  const DailyReport({
    required this.id,
    required this.userId,
    required this.date,
    required this.description,
    required this.hoursWorked,
    this.achievements,
    this.challenges,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final String date;
  final String description;
  final double hoursWorked;
  final String? achievements;
  final String? challenges;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  @override
  List<Object?> get props => <Object?>[
        id,
        userId,
        date,
        description,
        hoursWorked,
        achievements,
        challenges,
        notes,
        createdAt,
        updatedAt,
      ];
}

