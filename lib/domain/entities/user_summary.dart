import 'package:equatable/equatable.dart';

class UserSummary extends Equatable {
  const UserSummary({
    required this.userId,
    required this.name,
    this.employeeNumber,
    this.totalWorkedHours,
    this.totalMissingHours,
    this.totalOvertimeHours,
    this.effectiveMissingHours,
    this.effectiveOvertimeHours,
    this.overtimeAmountIqd,
    this.absentDays,
  });

  final int userId;
  final String name;
  final String? employeeNumber;
  final double? totalWorkedHours;
  final double? totalMissingHours;
  final double? totalOvertimeHours;
  final double? effectiveMissingHours;
  final double? effectiveOvertimeHours;
  final int? overtimeAmountIqd;
  final int? absentDays;

  @override
  List<Object?> get props => <Object?>[
        userId,
        name,
        employeeNumber,
        totalWorkedHours,
        totalMissingHours,
        totalOvertimeHours,
        effectiveMissingHours,
        effectiveOvertimeHours,
        overtimeAmountIqd,
        absentDays,
      ];
}




