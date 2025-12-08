import '../entities/user_request.dart';
import '../repositories/request_repository.dart';

class GetAllRequestsUseCase {
  GetAllRequestsUseCase(this._repository);

  final RequestRepository _repository;

  Future<List<UserRequest>> call() => _repository.getAllRequests();
}




