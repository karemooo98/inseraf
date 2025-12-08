import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserByIdUseCase {
  GetUserByIdUseCase(this._repository);

  final UserRepository _repository;

  Future<User> call(int userId) => _repository.getUserById(userId);
}

