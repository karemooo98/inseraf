import '../entities/user_request.dart';
import '../repositories/request_repository.dart';

class CreateRequestUseCase {
  CreateRequestUseCase(this._repository);

  final RequestRepository _repository;

  Future<UserRequest> call(CreateRequestParams params) => _repository.createRequest(
        type: params.type,
        reason: params.reason,
        date: params.date,
        startDate: params.startDate,
        endDate: params.endDate,
        checkIn: params.checkIn,
        checkOut: params.checkOut,
        leaveType: params.leaveType,
      );
}

class CreateRequestParams {
  const CreateRequestParams({
    required this.type,
    required this.reason,
    this.date,
    this.startDate,
    this.endDate,
    this.checkIn,
    this.checkOut,
    this.leaveType,
  });

  final String type;
  final String reason;
  final String? date;
  final String? startDate;
  final String? endDate;
  final String? checkIn;
  final String? checkOut;
  final String? leaveType;
}




