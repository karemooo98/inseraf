import '../../domain/entities/overtime_record.dart';
import '../../domain/repositories/overtime_repository.dart';
import '../datasources/remote_api_service.dart';
import '../models/overtime_record_model.dart';

class OvertimeRepositoryImpl implements OvertimeRepository {
  OvertimeRepositoryImpl(this._api);

  final RemoteApiService _api;

  @override
  Future<List<OvertimeRecord>> getMyOvertime() async {
    final dynamic response = await _api.getMyOvertime();
    final List<Map<String, dynamic>> parsed = _asList(response);
    return parsed
        .map((Map<String, dynamic> item) => OvertimeRecordModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<OvertimeRecord>> getAllOvertime() async {
    final dynamic response = await _api.getAllOvertime();
    final List<Map<String, dynamic>> parsed = _asList(response);
    return parsed
        .map((Map<String, dynamic> item) => OvertimeRecordModel.fromJson(item))
        .toList();
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    if (response is List) {
      return response.map((dynamic item) => Map<String, dynamic>.from(item as Map)).toList();
    }
    if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        return data.map((dynamic item) => Map<String, dynamic>.from(item as Map)).toList();
      }
    }
    return <Map<String, dynamic>>[];
  }
}

