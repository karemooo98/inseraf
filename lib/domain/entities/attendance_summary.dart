import 'package:equatable/equatable.dart';

class AttendanceSummary extends Equatable {
  const AttendanceSummary({
    required this.totalUsers,
    required this.present,
    required this.absent,
    required this.missingCheckout,
    required this.onTime,
    required this.leftEarly,
  });

  final int totalUsers;
  final int present;
  final int absent;
  final int missingCheckout;
  final int onTime;
  final int leftEarly;

  @override
  List<Object?> get props => <Object?>[
        totalUsers,
        present,
        absent,
        missingCheckout,
        onTime,
        leftEarly,
      ];
}
