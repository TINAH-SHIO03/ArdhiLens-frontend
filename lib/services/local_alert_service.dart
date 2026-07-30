import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../controllers/seller_home_controller.dart';
import '../core/storage_service.dart';
import '../models/notification_item.dart';
import 'notification_service.dart';

/// Shows local device alerts for new in-app notifications and registers
/// a stable device token with the backend alert module.
class LocalAlertService extends GetxService {
  LocalAlertService(this._notificationService, this._storage);

  final NotificationService _notificationService;
  final StorageService _storage;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<LocalAlertService> init() async {
    if (_initialized) return this;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;
    return this;
  }

  Future<void> ensureDeviceTokenRegistered() async {
    var token = _storage.deviceToken;
    if (token == null || token.isEmpty) {
      token =
          'ardhilens-${DateTime.now().millisecondsSinceEpoch}-${_storage.hashCode}';
      await _storage.setDeviceToken(token);
    }

    final platform = GetPlatform.isIOS ? 'ios' : 'android';
    try {
      await _notificationService.registerDeviceToken(token, platform);
    } catch (_) {
      // Token registration should not block the app.
    }
  }

  Future<void> pollAndAlert() async {
    try {
      final result = await _notificationService.getNotifications(page: 1);
      final list = result['notifications'] as List<NotificationItem>? ?? [];
      if (list.isEmpty) return;

      final lastSeen = _storage.lastNotificationSeenId;
      final newest = list.first;
      if (newest.id <= lastSeen) return;

      final fresh = list.where((n) => n.id > lastSeen && !n.isRead).toList();
      await _storage.setLastNotificationSeenId(newest.id);

      for (final item in fresh.take(3)) {
        await showLocalAlert(item.title, item.body);
        if (item.type == 'kyc_decision' &&
            Get.isRegistered<SellerHomeController>()) {
          // Admin changed KYC — refresh seller home from live API.
          unawaited(Get.find<SellerHomeController>().refreshDashboard());
        }
      }
    } catch (_) {
      // Silent poll failure.
    }
  }

  Future<void> showLocalAlert(String title, String body) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'ardhilens_alerts',
      'ArdhiLens Alerts',
      channelDescription: 'Land verification and risk alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }
}
