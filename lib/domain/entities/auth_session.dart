import 'package:equatable/equatable.dart';

import 'user.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.token,
    required this.user,
  });

  final String token;
  final User user;

  @override
  List<Object?> get props => <Object?>[token, user];
}




