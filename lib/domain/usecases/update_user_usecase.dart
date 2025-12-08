import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  UpdateUserUseCase(this._repository);

  final UserRepository _repository;

  Future<User> call({
    required int userId,
    String? name,
    String? email,
    String? password,
    String? role,
    int? employeeNumber,
    bool? isActive,
  }) =>
      _repository.updateUser(
        userId: userId,
        name: name,
        email: email,
        password: password,
        role: role,
        employeeNumber: employeeNumber,
        isActive: isActive,
      );
}

