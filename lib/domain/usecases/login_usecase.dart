import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call(LoginParams params) =>
      _repository.login(email: params.email, password: params.password);
}

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}




