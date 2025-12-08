import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class FetchProfileUseCase {
  FetchProfileUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call() => _repository.fetchProfile();
}




