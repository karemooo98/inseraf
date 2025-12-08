import 'package:equatable/equatable.dart';

class ShiftUser extends Equatable {
  const ShiftUser({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeNumber,
    this.effectiveFrom,
    this.effectiveTo,
    this.isActive,
  });

  final int id;
  final String name;
  final String email;
  final String employeeNumber;
  final String? effectiveFrom;
  final String? effectiveTo;
  final bool? isActive;

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    email,
    employeeNumber,
    effectiveFrom,
    effectiveTo,
    isActive,
  ];
}
