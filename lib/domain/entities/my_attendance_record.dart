import 'package:equatable/equatable.dart';

class MyAttendanceRecord extends Equatable {
  const MyAttendanceRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.dayName,
    this.firstCheckIn,
    this.lastCheckOut,
    this.totalHours,
    this.workedHours,
    this.missingHours,
    this.overtimeHours,
    this.overtimeAmountIqd,
    this.status,
    this.isLate,
    this.lateMinutes,
    this.isLocked,
  });

  final int id;
  final int userId;
  final String date;
  final String dayName;
  final String? firstCheckIn;
  final String? lastCheckOut;
  final double? totalHours;
  final double? workedHours;
  final double? missingHours;
  final double? overtimeHours;
  final int? overtimeAmountIqd;
  final String? status;
  final bool? isLate;
  final int? lateMinutes;
  final bool? isLocked;

  @override
  List<Object?> get props => <Object?>[
        id,
        userId,
        date,
        dayName,
        firstCheckIn,
        lastCheckOut,
        totalHours,
        workedHours,
        missingHours,
        overtimeHours,
        overtimeAmountIqd,
        status,
        isLate,
        lateMinutes,
        isLocked,
      ];
}

