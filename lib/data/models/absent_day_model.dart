import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/absent_day.dart';

part 'absent_day_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AbsentDayModel extends AbsentDay {
  const AbsentDayModel({
    required super.date,
    required super.dayName,
  });

  factory AbsentDayModel.fromJson(Map<String, dynamic> json) => _$AbsentDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbsentDayModelToJson(this);
}

