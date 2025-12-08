import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetAllUsersUseCase {
  GetAllUsersUseCase(this._repository);

  final UserRepository _repository;

  Future<List<User>> call({String? role}) => _repository.getAllUsers(role: role);
}

