import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import 'user_model.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.token,
    required super.user,
  }) : super();

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      token: json['token']?.toString() ?? '',
      user: UserModel.fromJson(
        Map<String, dynamic>.from(json['user'] as Map),
      ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'token': token,
        'user': (user as UserModel).toJson(),
      };

  AuthSessionModel copyWith({
    String? token,
    User? user,
  }) {
    return AuthSessionModel(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}

