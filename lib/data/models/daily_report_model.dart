import '../../domain/entities/daily_report.dart';

class DailyReportModel extends DailyReport {
  const DailyReportModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.description,
    required super.hoursWorked,
    super.achievements,
    super.challenges,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    // Handle hours_worked as either string or number
    double hoursWorked;
    final dynamic hoursWorkedValue = json['hours_worked'];
    if (hoursWorkedValue is String) {
      hoursWorked = double.tryParse(hoursWorkedValue) ?? 0.0;
    } else if (hoursWorkedValue is num) {
      hoursWorked = hoursWorkedValue.toDouble();
    } else {
      hoursWorked = 0.0;
    }

    return DailyReportModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      date: json['date'] as String,
      description: json['description'] as String,
      hoursWorked: hoursWorked,
      achievements: json['achievements'] as String?,
      challenges: json['challenges'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_id': userId,
        'date': date,
        'description': description,
        'hours_worked': hoursWorked,
        'achievements': achievements,
        'challenges': challenges,
        'notes': notes,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

