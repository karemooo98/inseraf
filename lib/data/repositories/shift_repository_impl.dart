import '../../domain/entities/shift.dart';
import '../../domain/repositories/shift_repository.dart';
import '../datasources/remote_api_service.dart';
import '../models/shift_model.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  ShiftRepositoryImpl(this._api);

  final RemoteApiService _api;

  @override
  Future<List<Shift>> getAllShifts() async {
    final dynamic response = await _api.getAllShifts();
    final List<Map<String, dynamic>> parsed = _asList(response);
    return parsed
        .map((Map<String, dynamic> item) => ShiftModel.fromJson(item))
        .toList();
  }

  @override
  Future<Shift> getShiftById(int shiftId) async {
    final Map<String, dynamic> response = await _api.getShiftById(shiftId);
    final Map<String, dynamic> data =
        response['data'] as Map<String, dynamic>? ?? response;
    return ShiftModel.fromJson(data);
  }

  @override
  Future<Shift> createShift({
    required String name,
    required String startTime,
    required String endTime,
    int? gracePeriodMinutes,
    String? description,
  }) async {
    final Map<String, dynamic> response = await _api.createShift(
      name: name,
      startTime: startTime,
      endTime: endTime,
      gracePeriodMinutes: gracePeriodMinutes,
      description: description,
    );
    final Map<String, dynamic> data =
        response['data'] as Map<String, dynamic>? ?? response;
    return ShiftModel.fromJson(data);
  }

  @override
  Future<Shift> updateShift({
    required int shiftId,
    String? name,
    String? startTime,
    String? endTime,
    int? gracePeriodMinutes,
    String? description,
    bool? isActive,
  }) async {
    final Map<String, dynamic> response = await _api.updateShift(
      shiftId: shiftId,
      name: name,
      startTime: startTime,
      endTime: endTime,
      gracePeriodMinutes: gracePeriodMinutes,
      description: description,
      isActive: isActive,
    );
    final Map<String, dynamic> data =
        response['data'] as Map<String, dynamic>? ?? response;
    return ShiftModel.fromJson(data);
  }

  @override
  Future<void> deleteShift(int shiftId) async {
    await _api.deleteShift(shiftId);
  }

  @override
  Future<void> assignUsersToShift({
    required int shiftId,
    required List<int> userIds,
    String? effectiveFrom,
    String? effectiveTo,
  }) async {
    await _api.assignUsersToShift(
      shiftId: shiftId,
      userIds: userIds,
      effectiveFrom: effectiveFrom,
      effectiveTo: effectiveTo,
    );
  }

  @override
  Future<void> removeUserFromShift({
    required int shiftId,
    required int userId,
  }) async {
    await _api.removeUserFromShift(shiftId: shiftId, userId: userId);
  }

  @override
  Future<Shift?> getMyShift() async {
    final dynamic response = await _api.getMyShift();
    if (response is Map<String, dynamic>) {
      final bool hasShift = response['has_shift'] as bool? ?? false;
      if (!hasShift) return null;
      final dynamic data = response['data'];
      if (data != null && data is Map<String, dynamic>) {
        return ShiftModel.fromJson(data);
      }
    }
    return null;
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    if (response is List) {
      return response
          .map((dynamic item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        return data
            .map((dynamic item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
    }
    return <Map<String, dynamic>>[];
  }
}
