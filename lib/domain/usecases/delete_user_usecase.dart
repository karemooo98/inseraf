import '../repositories/user_repository.dart';

class DeleteUserUseCase {
  DeleteUserUseCase(this._repository);

  final UserRepository _repository;

  Future<void> call(int userId) => _repository.deleteUser(userId);
}

