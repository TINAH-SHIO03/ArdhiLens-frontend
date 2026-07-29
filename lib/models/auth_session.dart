import 'auth_user.dart';
import 'parsing.dart';

class AuthSession {
  AuthSession({required this.token, required this.user});

  final String token;
  final AuthUser user;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final userJson = asStringKeyMap(json['user']) ?? <String, dynamic>{};

    return AuthSession(
      token: asString(json['token']),
      user: AuthUser.fromJson(userJson),
    );
  }
}
