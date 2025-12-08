import '../entities/auth_session.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<AuthSession> login({required String email, required String password});

  Future<void> logout();

  Future<User> fetchProfile();
  Future<User> updateProfile({
    String? name,
    String? email,
    String? password,
    List<String>? weekendDays,
  });

  Future<AuthSession?> restoreSession();
}
