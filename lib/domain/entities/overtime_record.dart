import 'package:equatable/equatable.dart';

class OvertimeRecord extends Equatable {
  const OvertimeRecord({
    required this.id,
    required this.date,
    required this.hours,
    required this.status,
    required this.employeeId,
    this.description,
    this.employeeName,
    this.employeeNumber,
    this.managerId,
    this.managerName,
    this.createdAt,
  });

  final int id;
  final String date;
  final double hours;
  final String? description;
  final String status; // 'pending', 'approved', 'rejected'
  final int employeeId;
  final String? employeeName;
  final String? employeeNumber;
  final int? managerId;
  final String? managerName;
  final String? createdAt;

  @override
  List<Object?> get props => <Object?>[
        id,
        date,
        hours,
        description,
        status,
        employeeId,
        employeeName,
        employeeNumber,
        managerId,
        managerName,
        createdAt,
      ];
}

