import 'package:equatable/equatable.dart';

class AbsentDay extends Equatable {
  const AbsentDay({
    required this.date,
    required this.dayName,
  });

  final String date;
  final String dayName;

  @override
  List<Object?> get props => <Object?>[date, dayName];
}

