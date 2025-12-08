import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote_api_service.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._api);

  final RemoteApiService _api;

  @override
  Future<List<User>> getAllUsers({String? role}) async {
    final dynamic response = await _api.getAllUsers(role: role);
    final List<Map<String, dynamic>> parsed = _asList(response);
    return parsed.map((Map<String, dynamic> item) => UserModel.fromJson(item)).toList();
  }

  @override
  Future<User> getUserById(int userId) async {
    final Map<String, dynamic> response = await _api.getUserById(userId);
    return UserModel.fromJson(response);
  }

  @override
  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    int? employeeNumber,
    bool? isActive,
  }) async {
    final Map<String, dynamic> response = await _api.createUser(
      name: name,
      email: email,
      password: password,
      role: role,
      employeeNumber: employeeNumber,
      isActive: isActive,
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<User> updateUser({
    required int userId,
    String? name,
    String? email,
    String? password,
    String? role,
    int? employeeNumber,
    bool? isActive,
  }) async {
    final Map<String, dynamic> response = await _api.updateUser(
      userId: userId,
      name: name,
      email: email,
      password: password,
      role: role,
      employeeNumber: employeeNumber,
      isActive: isActive,
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<void> deleteUser(int userId) async {
    await _api.deleteUser(userId);
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    if (response is List) {
      return response.map((dynamic item) => Map<String, dynamic>.from(item as Map)).toList();
    }
    if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        return data.map((dynamic item) => Map<String, dynamic>.from(item as Map)).toList();
      }
    }
    return <Map<String, dynamic>>[];
  }
}

