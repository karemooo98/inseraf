import 'package:equatable/equatable.dart';

class TeamMember extends Equatable {
  const TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeNumber,
    required this.teamRole,
  });

  final int id;
  final String name;
  final String email;
  final String employeeNumber;
  final String teamRole; // 'manager' or 'employee'

  @override
  List<Object?> get props => <Object?>[id, name, email, employeeNumber, teamRole];
}

