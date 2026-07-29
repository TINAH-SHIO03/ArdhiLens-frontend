import '../core/api_client.dart';
import '../core/api_exception.dart';

class SellerService {
  SellerService(this._apiClient);

  final ApiClient _apiClient;

  /// Lightweight seller home summary (plots + KYC + counts only).
  Future<Map<String, dynamic>> dashboard() async {
    final json = await _apiClient.get('/seller/dashboard');
    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;
    if (!success || data == null) {
      throw ApiException(
        message: json['message']?.toString() ?? 'Seller dashboard failed',
      );
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> recentVerifications() async {
    final json = await _apiClient.get('/seller/recent-verifications');
    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;
    if (!success || data == null) {
      throw ApiException(
        message:
            json['message']?.toString() ?? 'Could not load recent verifications',
      );
    }
    final raw = data['recent_buyer_verifications'];
    if (raw is! List) return [];
    return raw.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }

  Future<Map<String, dynamic>> submitKyc({
    required String nin,
    String? selfieBase64,
  }) async {
    final json = await _apiClient.post(
      '/seller/kyc',
      data: {
        'nin': nin,
        if (selfieBase64 != null) 'selfie_base64': selfieBase64,
      },
    );
    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;
    if (!success || data == null) {
      throw ApiException(message: json['message']?.toString() ?? 'KYC failed');
    }
    return data;
  }
}
