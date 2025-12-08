import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.employeeNumber,
    this.isActive = true,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final String? employeeNumber;
  final bool isActive;

  bool get isAdmin => role == 'admin';
  bool get isManager => role == 'manager';
  bool get isEmployee => role == 'employee';

  @override
  List<Object?> get props => <Object?>[id, email, role, employeeNumber, isActive];
}




