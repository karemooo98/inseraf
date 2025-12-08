import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getAllUsers({String? role});
  Future<User> getUserById(int userId);
  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    int? employeeNumber,
    bool? isActive,
  });
  Future<User> updateUser({
    required int userId,
    String? name,
    String? email,
    String? password,
    String? role,
    int? employeeNumber,
    bool? isActive,
  });
  Future<void> deleteUser(int userId);
}

