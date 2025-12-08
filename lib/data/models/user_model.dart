import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.employeeNumber,
    super.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        employeeNumber: json['employee_number']?.toString(),
        isActive: json['is_active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'employee_number': employeeNumber,
        'is_active': isActive,
      };

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? employeeNumber,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      isActive: isActive ?? this.isActive,
    );
  }
}




