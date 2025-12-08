import '../entities/user.dart';
import '../repositories/user_repository.dart';

class CreateUserUseCase {
  CreateUserUseCase(this._repository);

  final UserRepository _repository;

  Future<User> call({
    required String name,
    required String email,
    required String password,
    required String role,
    int? employeeNumber,
    bool? isActive,
  }) =>
      _repository.createUser(
        name: name,
        email: email,
        password: password,
        role: role,
        employeeNumber: employeeNumber,
        isActive: isActive,
      );
}

