import '../entities/user_request.dart';

abstract interface class RequestRepository {
  Future<List<UserRequest>> getMyRequests();

  Future<List<UserRequest>> getAllRequests();

  Future<UserRequest> createRequest({
    required String type,
    required String reason,
    String? date,
    String? startDate,
    String? endDate,
    String? checkIn,
    String? checkOut,
    String? leaveType,
  });

  Future<UserRequest> approveRequest({
    required int requestId,
    required bool approve,
    String? note,
  });
  Future<UserRequest> getRequestById(int requestId);
}




