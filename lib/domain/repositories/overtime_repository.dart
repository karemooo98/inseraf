import '../entities/overtime_record.dart';

abstract class OvertimeRepository {
  Future<List<OvertimeRecord>> getMyOvertime();
  Future<List<OvertimeRecord>> getAllOvertime();
}

