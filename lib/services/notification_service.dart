import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/notification_item.dart';

class NotificationService {
  NotificationService(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getNotifications({int page = 1, int perPage = 20}) async {
    final json = await _apiClient.get(
      '/notifications?page=$page&per_page=$perPage',
    );

    final success = json['success'] as bool? ?? false;
    final message = json['message'] as String? ?? '';
    final data = json['data'] as Map<String, dynamic>?;

    if (!success || data == null) {
      throw ApiException(message: message);
    }

    final notificationsRaw = data['notifications'] as List? ?? [];
    final notifications = notificationsRaw
        .map((item) => NotificationItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return {
      'notifications': notifications,
      'total': data['total'] as int? ?? 0,
      'page': data['page'] as int? ?? 1,
      'perPage': data['per_page'] as int? ?? 20,
      'totalPages': data['total_pages'] as int? ?? 1,
      'unreadCount': data['unread_count'] as int? ?? 0,
    };
  }

  Future<int> getUnreadCount() async {
    final json = await _apiClient.get('/notifications/unread-count');

    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;

    if (!success || data == null) {
      return 0;
    }

    return data['unread_count'] as int? ?? 0;
  }

  Future<void> markAsRead(int id) async {
    final json = await _apiClient.put(
      '/notifications/$id/read',
      data: {},
    );

    final success = json['success'] as bool? ?? false;
    if (!success) {
      final message = json['message'] as String? ?? 'Failed to mark as read.';
      throw ApiException(message: message);
    }
  }

  Future<void> markAllAsRead() async {
    final json = await _apiClient.put(
      '/notifications/read-all',
      data: {},
    );

    final success = json['success'] as bool? ?? false;
    if (!success) {
      final message = json['message'] as String? ?? 'Failed to mark all as read.';
      throw ApiException(message: message);
    }
  }

  Future<void> deleteNotification(int id) async {
    final json = await _apiClient.delete('/notifications/$id');

    final success = json['success'] as bool? ?? false;
    if (!success) {
      final message = json['message'] as String? ?? 'Failed to delete notification.';
      throw ApiException(message: message);
    }
  }

  Future<void> registerDeviceToken(String token, String platform) async {
    final json = await _apiClient.post(
      '/notifications/device-token',
      data: {'token': token, 'platform': platform},
    );

    final success = json['success'] as bool? ?? false;
    if (!success) {
      final message = json['message'] as String? ?? 'Failed to register device token.';
      throw ApiException(message: message);
    }
  }
}
