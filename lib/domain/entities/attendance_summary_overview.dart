import 'package:equatable/equatable.dart';

class AttendanceSummaryOverview extends Equatable {
  const AttendanceSummaryOverview({
    required this.totalUsers,
    required this.present,
    required this.absent,
    required this.missingCheckout,
    required this.onTime,
    required this.leftEarly,
    required this.averageHours,
  });

  final int totalUsers;
  final int present;
  final int absent;
  final int missingCheckout;
  final int onTime;
  final int leftEarly;
  final double averageHours;

  @override
  List<Object?> get props => <Object?>[
        totalUsers,
        present,
        absent,
        missingCheckout,
        onTime,
        leftEarly,
        averageHours,
      ];
}

