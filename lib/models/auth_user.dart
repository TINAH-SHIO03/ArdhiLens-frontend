import 'parsing.dart';

class AuthUser {
  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phoneNumber,
    required this.isActive,
    this.nin,
    this.emailVerified = false,
    this.kycStatus = 'none',
    this.hasAvatar = false,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final String? phoneNumber;
  final bool isActive;
  final String? nin;
  final bool emailVerified;
  final String kycStatus;
  final bool hasAvatar;

  bool get isSeller => role.toLowerCase() == 'seller';
  bool get isBuyer => role.toLowerCase() == 'buyer';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: asInt(json['id']) ?? 0,
      name: asString(json['name']),
      email: asString(json['email']),
      role: asString(json['role'], fallback: 'buyer'),
      phoneNumber: json['phone_number']?.toString(),
      isActive: asBool(json['is_active']) ?? false,
      nin: json['nin']?.toString(),
      emailVerified: asBool(json['email_verified']) ??
          (json['email_verified_at'] != null),
      kycStatus: asString(json['kyc_status'], fallback: 'none'),
      hasAvatar: asBool(json['has_avatar']) ?? false,
    );
  }
}
