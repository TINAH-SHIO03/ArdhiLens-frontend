import 'auth_user.dart';

class AuthSession {
  AuthSession({required this.token, required this.user});

  final String token;
  final AuthUser user;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final userJson =
        (json['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    return AuthSession(
      token: json['token'] as String? ?? '',
      user: AuthUser.fromJson(userJson),
    );
  }
}
