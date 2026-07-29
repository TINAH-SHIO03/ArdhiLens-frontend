import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notification_controller.dart';
import '../models/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationController get controller => Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.openInbox(force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A3D2E), Color(0xFF1A6B4A)],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'notif_title'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            actions: [
              Obx(() {
                if (controller.unreadCount.value == 0) {
                  return const SizedBox.shrink();
                }
                return TextButton(
                  onPressed: controller.markAllAsRead,
                  child: Text(
                    'notif_mark_all_read'.tr,
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF1A6B4A),
          onRefresh: () => controller.fetchNotifications(refresh: true),
          child: Obx(() {
            if (controller.isLoading.value && controller.notifications.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1A6B4A)),
              );
            }

            if (controller.notifications.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  _buildEmptyState(),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              itemCount: controller.notifications.length +
                  (controller.currentPage.value < controller.totalPages.value
                      ? 1
                      : 0),
              itemBuilder: (context, index) {
                if (index == controller.notifications.length) {
                  controller.loadMore();
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1A6B4A),
                        strokeWidth: 2.5,
                      ),
                    ),
                  );
                }

                final item = controller.notifications[index];
                return _NotificationCard(
                  item: item,
                  onTap: () {
                    if (!item.isRead) {
                      controller.markAsRead(item.id);
                    }
                  },
                  onDismissed: () {
                    controller.deleteNotification(item.id);
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 36,
                color: Color(0xFFBDBDBD),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'You\'re all caught up! New notifications will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF9E9E9E),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.onTap,
    required this.onDismissed,
  });

  final NotificationItem item;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('notif_delete_title'.tr),
              content: Text('notif_delete_confirm'.tr),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    'common_cancel'.tr,
                    style: const TextStyle(color: Color(0xFF9E9E9E)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    'common_delete'.tr,
                    style: const TextStyle(color: Color(0xFFDC2626)),
                  ),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) => onDismissed(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: item.isRead
                    ? Colors.white
                    : const Color(0xFFD4AF37).withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: item.isRead
                    ? null
                    : Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                        width: 1,
                      ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!item.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4AF37),
                        shape: BoxShape.circle,
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _typeInfo(item.type).background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _typeInfo(item.type).icon,
                      size: 20,
                      color: _typeInfo(item.type).color,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: item.isRead
                                      ? FontWeight.w600
                                      : FontWeight.w700,
                                  color: const Color(0xFF1A1A1A),
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.body,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF757575),
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: Color(0xFFBDBDBD),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _relativeTime(item.createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _TypeInfo _typeInfo(String type) {
    switch (type) {
      case 'verification_result':
        return _TypeInfo(
          icon: Icons.check_circle_rounded,
          color: const Color(0xFF1A6B4A),
          background: const Color(0xFF0A3D2E).withValues(alpha: 0.08),
        );
      case 'plot_status_change':
        return _TypeInfo(
          icon: Icons.swap_horiz_rounded,
          color: const Color(0xFF2563EB),
          background: const Color(0xFF2563EB).withValues(alpha: 0.08),
        );
      case 'risk_score_alert':
        return _TypeInfo(
          icon: Icons.warning_rounded,
          color: const Color(0xFFF59E0B),
          background: const Color(0xFFF59E0B).withValues(alpha: 0.08),
        );
      default:
        return _TypeInfo(
          icon: Icons.info_rounded,
          color: const Color(0xFF6B7280),
          background: const Color(0xFF6B7280).withValues(alpha: 0.08),
        );
    }
  }

  String _relativeTime(String isoString) {
    final parsed = DateTime.tryParse(isoString);
    if (parsed == null) return isoString;

    final now = DateTime.now();
    final diff = now.difference(parsed.toLocal());

    if (diff.isNegative) return 'Just now';
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m min ago';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h hour${h == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 7) {
      final d = diff.inDays;
      return '$d day${d == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 30) {
      final w = (diff.inDays / 7).floor();
      return '$w week${w == 1 ? '' : 's'} ago';
    }
    final months = (diff.inDays / 30).floor();
    return '$months month${months == 1 ? '' : 's'} ago';
  }
}

class _TypeInfo {
  const _TypeInfo({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;
}
