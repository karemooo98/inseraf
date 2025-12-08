import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase {
  UpdateProfileUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    String? name,
    String? email,
    String? password,
    List<String>? weekendDays,
  }) => _repository.updateProfile(
    name: name,
    email: email,
    password: password,
    weekendDays: weekendDays,
  );
}
