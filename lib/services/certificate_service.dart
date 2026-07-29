import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/verification_certificate.dart';

class CertificateService {
  CertificateService(this._apiClient);

  final ApiClient _apiClient;

  Future<VerificationCertificate> generateCertificate(
    int verificationLogId,
  ) async {
    final json = await _apiClient.post(
      '/certificates/generate',
      data: {'verification_log_id': verificationLogId},
    );

    final success = json['success'] as bool? ?? false;
    final message = json['message'] as String? ?? '';
    final data = json['data'] as Map<String, dynamic>?;

    if (!success || data == null) {
      throw ApiException(message: message);
    }

    final certData = data['certificate'] as Map<String, dynamic>?;
    if (certData == null) {
      throw ApiException(message: 'Certificate data not found.');
    }

    return VerificationCertificate.fromJson(certData);
  }

  Future<List<VerificationCertificate>> listCertificates() async {
    final json = await _apiClient.get('/certificates');

    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;

    if (!success || data == null) {
      return [];
    }

    final certsRaw = data['certificates'] as List? ?? [];
    return certsRaw
        .map(
          (item) =>
              VerificationCertificate.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<int>> downloadCertificateBytes(int id) {
    return _apiClient.downloadBytes('/certificates/$id/download');
  }

  Future<Map<String, dynamic>> verifyCertificate(
    String certificateNumber,
  ) async {
    final json = await _apiClient.get(
      '/certificates/verify/$certificateNumber',
      requiresAuth: false,
    );

    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;

    if (!success || data == null) {
      final message = json['message'] as String? ?? 'Certificate not found.';
      throw ApiException(message: message);
    }

    return data;
  }
}
