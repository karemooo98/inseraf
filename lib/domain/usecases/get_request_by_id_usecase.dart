import '../entities/user_request.dart';
import '../repositories/request_repository.dart';

class GetRequestByIdUseCase {
  GetRequestByIdUseCase(this._repository);

  final RequestRepository _repository;

  Future<UserRequest> call(int requestId) => _repository.getRequestById(requestId);
}

