import '../core/api_client.dart';
import '../core/api_exception.dart';

class InterestService {
  InterestService(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> expressInterest({
    required String plotReference,
    String? message,
    int? verificationLogId,
  }) async {
    final json = await _apiClient.post(
      '/buyer/interests',
      data: {
        'plot_reference': plotReference,
        if (message != null && message.isNotEmpty) 'message': message,
        if (verificationLogId != null) 'verification_log_id': verificationLogId,
      },
    );
    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;
    if (!success || data == null) {
      throw ApiException(
        message: json['message']?.toString() ?? 'Could not send interest',
      );
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> buyerInterests() async {
    final json = await _apiClient.get('/buyer/interests');
    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;
    if (!success || data == null) {
      throw ApiException(
        message: json['message']?.toString() ?? 'Could not load interests',
      );
    }
    final raw = data['interests'];
    if (raw is! List) return [];
    return raw.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }

  Future<List<Map<String, dynamic>>> sellerInterests() async {
    final json = await _apiClient.get('/seller/interests');
    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;
    if (!success || data == null) {
      throw ApiException(
        message: json['message']?.toString() ?? 'Could not load buyer requests',
      );
    }
    final raw = data['interests'];
    if (raw is! List) return [];
    return raw.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }

  Future<Map<String, dynamic>> respond({
    required int interestId,
    required String status,
    String? reply,
  }) async {
    final json = await _apiClient.put(
      '/seller/interests/$interestId/respond',
      data: {
        'status': status,
        if (reply != null && reply.isNotEmpty) 'reply': reply,
      },
    );
    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;
    if (!success || data == null) {
      throw ApiException(
        message: json['message']?.toString() ?? 'Could not respond',
      );
    }
    return data;
  }
}
