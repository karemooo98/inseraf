import '../entities/user_request.dart';
import '../repositories/request_repository.dart';

class GetMyRequestsUseCase {
  GetMyRequestsUseCase(this._repository);

  final RequestRepository _repository;

  Future<List<UserRequest>> call() => _repository.getMyRequests();
}




