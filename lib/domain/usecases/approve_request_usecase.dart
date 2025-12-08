import '../entities/user_request.dart';
import '../repositories/request_repository.dart';

class ApproveRequestUseCase {
  ApproveRequestUseCase(this._repository);

  final RequestRepository _repository;

  Future<UserRequest> call(ApproveRequestParams params) => _repository.approveRequest(
        requestId: params.requestId,
        approve: params.approve,
        note: params.note,
      );
}

class ApproveRequestParams {
  const ApproveRequestParams({
    required this.requestId,
    required this.approve,
    this.note,
  });

  final int requestId;
  final bool approve;
  final String? note;
}




