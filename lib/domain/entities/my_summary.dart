import 'package:equatable/equatable.dart';

import '../../core/utils/typedefs.dart';
import 'absent_day.dart';
import 'my_attendance_record.dart';

class MySummary extends Equatable {
  const MySummary({
    required this.attendance,
    required this.missingDaysCount,
    required this.absentDays,
    required this.weekendDays,
    this.statistics,
    this.overtime,
    this.tasks,
  });

  final List<MyAttendanceRecord> attendance;
  final int missingDaysCount;
  final List<AbsentDay> absentDays;
  final List<String> weekendDays;
  final JsonMap? statistics;
  final List<JsonMap>? overtime;
  final List<JsonMap>? tasks;

  @override
  List<Object?> get props => <Object?>[
        attendance,
        missingDaysCount,
        absentDays,
        weekendDays,
        statistics,
        overtime,
        tasks,
      ];
}

