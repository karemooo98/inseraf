import 'package:equatable/equatable.dart';

class UserRequest extends Equatable {
  const UserRequest({
    required this.id,
    required this.type,
    required this.reason,
    required this.status,
    this.userId,
    this.userName,
    this.userEmail,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.leaveType,
    this.date,
    this.checkIn,
    this.checkOut,
    this.approvedBy,
    this.approvedAt,
    this.approveNote,
  });

  final int id;
  final int? userId;
  final String? userName;
  final String? userEmail;
  final String type;
  final String reason;
  final String status;
  final String? startDate;
  final String? endDate;
  final int? totalDays;
  final String? leaveType;
  final String? date;
  final String? checkIn;
  final String? checkOut;
  final int? approvedBy;
  final String? approvedAt;
  final String? approveNote;

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  @override
  List<Object?> get props => <Object?>[
        id,
        userId,
        userName,
        userEmail,
        type,
        status,
        reason,
        startDate,
        endDate,
        totalDays,
        leaveType,
        date,
        checkIn,
        checkOut,
        approvedBy,
        approvedAt,
        approveNote,
      ];
}




