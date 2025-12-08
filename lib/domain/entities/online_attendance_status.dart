import 'package:equatable/equatable.dart';

class OnlineAttendanceStatus extends Equatable {
  const OnlineAttendanceStatus({
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.totalHours,
    this.isLocked,
    this.canCheckIn,
    this.canCheckOut,
    this.currentIraqTime,
    this.message,
  });

  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final double? totalHours;
  final bool? isLocked;
  final bool? canCheckIn;
  final bool? canCheckOut;
  final String? currentIraqTime;
  final String? message;

  @override
  List<Object?> get props => <Object?>[
        date,
        checkInTime,
        checkOutTime,
        totalHours,
        isLocked,
        canCheckIn,
        canCheckOut,
        currentIraqTime,
        message,
      ];
}

