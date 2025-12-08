import 'package:equatable/equatable.dart';

import 'shift_user.dart';

class Shift extends Equatable {
  const Shift({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    this.gracePeriodMinutes,
    this.description,
    this.users = const <ShiftUser>[],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String startTime; // Format: "HH:mm:ss" or "HH:mm"
  final String endTime; // Format: "HH:mm:ss" or "HH:mm"
  final int? gracePeriodMinutes;
  final bool isActive;
  final String? description;
  final List<ShiftUser> users;
  final String? createdAt;
  final String? updatedAt;

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    startTime,
    endTime,
    gracePeriodMinutes,
    isActive,
    description,
    users,
    createdAt,
    updatedAt,
  ];
}
