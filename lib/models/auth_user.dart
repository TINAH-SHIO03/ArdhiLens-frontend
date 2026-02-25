import 'parsing.dart';

class AuthUser {
  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phoneNumber,
    required this.isActive,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final String? phoneNumber;
  final bool isActive;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: asInt(json['id']) ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      phoneNumber: json['phone_number'] as String?,
      isActive: json['is_active'] as bool? ?? false,
    );
  }
}
