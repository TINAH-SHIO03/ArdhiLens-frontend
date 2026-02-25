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

  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phoneNumber,
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
    return envelope.data!;
  }

  Future<void> logout() async {
    await _apiClient.post('/auth/logout', data: const {});
    await _storage.clearAuthToken();
    await _storage.clearVerificationSession();
  }

  Future<AuthUser> me() async {
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

    return envelope.data!;
  }
}
