import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/api_envelope.dart';
import '../models/auth_session.dart';
import '../models/auth_user.dart';

class AuthService {
  AuthService(this._apiClient, this._storage);

  final ApiClient _apiClient;
  final StorageService _storage;

  AuthUser? _cachedUser;

  AuthUser? get cachedUser => _cachedUser;

  void clearCachedUser() => _cachedUser = null;

  Future<void> _persistSessionUser(AuthUser user) async {
    _cachedUser = user;
    await _storage.setUserRole(user.role);
    await _storage.setCurrentUserId(user.id);
  }

  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phoneNumber,
    String? role,
  }) async {
    final json = await _apiClient.post(
      '/auth/register',
      requiresAuth: false,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone_number': phoneNumber,
        'role': role,
      },
    );

    final envelope = ApiEnvelope<AuthSession>.fromJson(
      json,
      AuthSession.fromJson,
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }

    await _storage.setAuthToken(envelope.data!.token);
    await _persistSessionUser(envelope.data!.user);
    return envelope.data!;
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final json = await _apiClient.post(
      '/auth/login',
      requiresAuth: false,
      data: {'email': email, 'password': password},
    );

    final envelope = ApiEnvelope<AuthSession>.fromJson(
      json,
      AuthSession.fromJson,
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }

    await _storage.setAuthToken(envelope.data!.token);
    await _persistSessionUser(envelope.data!.user);
    return envelope.data!;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout', data: const {});
    } finally {
      clearCachedUser();
      await _storage.clearAuthToken();
      await _storage.clearVerificationSession();
    }
  }

  Future<AuthUser> me({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedUser != null) {
      return _cachedUser!;
    }

    final json = await _apiClient.get('/auth/me');

    final envelope = ApiEnvelope<AuthUser>.fromJson(json, (data) {
      final userJson =
          (data['user'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      return AuthUser.fromJson(userJson);
    });

    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }

    await _persistSessionUser(envelope.data!);
    return envelope.data!;
  }

  Future<AuthUser> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? nin,
  }) async {
    final json = await _apiClient.put(
      '/auth/profile',
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (nin != null) 'nin': nin,
      },
    );

    final envelope = ApiEnvelope<AuthUser>.fromJson(json, (data) {
      final userJson =
          (data['user'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      return AuthUser.fromJson(userJson);
    });

    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }

    await _persistSessionUser(envelope.data!);
    return envelope.data!;
  }

  Future<AuthUser> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split(RegExp(r'[\\/]')).last,
      ),
    });
    final json = await _apiClient.uploadMultipart(
      '/auth/avatar',
      formData: formData,
    );
    final envelope = ApiEnvelope<AuthUser>.fromJson(json, (data) {
      final userJson =
          (data['user'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      return AuthUser.fromJson(userJson);
    });
    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }
    await _persistSessionUser(envelope.data!);
    return envelope.data!;
  }

  Future<List<int>> downloadAvatarBytes() {
    return _apiClient.downloadBytes('/auth/avatar');
  }

  Future<Map<String, dynamic>?> requestPasswordReset(String email) async {
    final json = await _apiClient.post(
      '/auth/forgot-password',
      requiresAuth: false,
      data: {'email': email},
    );
    if (json['success'] != true) {
      throw ApiException(message: json['message']?.toString() ?? 'Request failed');
    }
    final data = json['data'];
    if (data is Map) {
      return data.cast<String, dynamic>();
    }
    return null;
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    final json = await _apiClient.post(
      '/auth/reset-password',
      requiresAuth: false,
      data: {
        'email': email,
        'code': code,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    if (json['success'] != true) {
      throw ApiException(message: json['message']?.toString() ?? 'Reset failed');
    }
  }

  Future<void> sendEmailVerificationCode() async {
    final json = await _apiClient.post('/auth/email/send-code', data: const {});
    if (json['success'] != true) {
      throw ApiException(message: json['message']?.toString() ?? 'Send failed');
    }
  }

  Future<AuthUser> verifyEmailCode(String code) async {
    final json = await _apiClient.post(
      '/auth/email/verify',
      data: {'code': code},
    );
    final envelope = ApiEnvelope<AuthUser>.fromJson(json, (data) {
      final userJson =
          (data['user'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      return AuthUser.fromJson(userJson);
    });
    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }
    await _persistSessionUser(envelope.data!);
    return envelope.data!;
  }
}
