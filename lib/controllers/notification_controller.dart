import 'dart:async';

import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/notification_item.dart';
import '../services/local_alert_service.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService;

  NotificationController(this._notificationService);

  final notifications = <NotificationItem>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final total = 0.obs;

  Timer? _pollTimer;
  bool _listLoaded = false;

  @override
  void onInit() {
    super.onInit();
    // Only badge count on cold start — do not load the full notification list.
    if (Get.find<StorageService>().isAuthenticated) {
      onAuthenticated();
    }
  }

  /// After login/register: badge + light poll only (no full list fetch).
  Future<void> onAuthenticated() async {
    await refreshUnreadCount();
    _startAlertLoop();
  }

  void onLoggedOut() {
    _pollTimer?.cancel();
    notifications.clear();
    unreadCount.value = 0;
    total.value = 0;
    currentPage.value = 1;
    totalPages.value = 1;
    _listLoaded = false;
  }

  void _startAlertLoop() {
    final storage = Get.find<StorageService>();
    if (!storage.isAuthenticated) return;

    Future.microtask(() async {
      if (Get.isRegistered<LocalAlertService>()) {
        final alerts = Get.find<LocalAlertService>();
        await alerts.ensureDeviceTokenRegistered();
      }
    });

    _pollTimer?.cancel();
    // Poll unread badge only. Full list loads when Notifications screen opens.
    _pollTimer = Timer.periodic(const Duration(seconds: 60), (_) async {
      if (!Get.find<StorageService>().isAuthenticated) return;
      final previous = unreadCount.value;
      await refreshUnreadCount();
      if (unreadCount.value > previous &&
          Get.isRegistered<LocalAlertService>()) {
        await Get.find<LocalAlertService>().pollAndAlert();
      }
    });
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (!Get.find<StorageService>().isAuthenticated) return;
    if (isLoading.value) return;

    if (refresh) {
      currentPage.value = 1;
    }

    isLoading.value = true;

    try {
      final result = await _notificationService.getNotifications(
        page: currentPage.value,
      );

      final list = result['notifications'] as List<NotificationItem>? ?? [];

      if (refresh || currentPage.value == 1) {
        notifications.assignAll(list);
      } else {
        notifications.addAll(list);
      }

      total.value = result['total'] as int? ?? 0;
      totalPages.value = result['totalPages'] as int? ?? 1;
      unreadCount.value = result['unreadCount'] as int? ?? unreadCount.value;
      _listLoaded = true;
    } on ApiException catch (e) {
      if (e.statusCode != 401) {
        Get.snackbar(
          'common_error'.tr,
          e.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Call from Notifications screen only.
  Future<void> openInbox({bool force = false}) async {
    if (!_listLoaded || force) {
      await fetchNotifications(refresh: true);
    } else {
      await refreshUnreadCount();
    }
  }

  Future<void> loadMore() async {
    if (currentPage.value >= totalPages.value) return;
    currentPage.value++;
    await fetchNotifications();
  }

  Future<void> refreshUnreadCount() async {
    if (!Get.find<StorageService>().isAuthenticated) return;
    try {
      unreadCount.value = await _notificationService.getUnreadCount();
    } catch (_) {
      // Silently fail
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _notificationService.markAsRead(id);

      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final old = notifications[index];
        notifications[index] = NotificationItem(
          id: old.id,
          type: old.type,
          title: old.title,
          body: old.body,
          data: old.data,
          readAt: DateTime.now().toIso8601String(),
          createdAt: old.createdAt,
        );
      }

      unreadCount.value = (unreadCount.value - 1).clamp(0, 999);
    } on ApiException catch (e) {
      Get.snackbar(
        'common_error'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();

      for (var i = 0; i < notifications.length; i++) {
        final old = notifications[i];
        if (!old.isRead) {
          notifications[i] = NotificationItem(
            id: old.id,
            type: old.type,
            title: old.title,
            body: old.body,
            data: old.data,
            readAt: DateTime.now().toIso8601String(),
            createdAt: old.createdAt,
          );
        }
      }

      unreadCount.value = 0;
    } on ApiException catch (e) {
      Get.snackbar(
        'common_error'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      await _notificationService.deleteNotification(id);
      final removed = notifications.firstWhereOrNull((n) => n.id == id);
      notifications.removeWhere((n) => n.id == id);
      if (total.value > 0) total.value--;
      if (removed != null && !removed.isRead && unreadCount.value > 0) {
        unreadCount.value--;
      } else {
        await refreshUnreadCount();
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'common_error'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
