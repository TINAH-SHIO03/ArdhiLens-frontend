import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/notification_controller.dart';
import '../design/verdict_style.dart';
import '../routes/app_routes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF1A6B4A),
          onRefresh: () => controller.loadHomeData(forceRefreshUser: true),
          child: Obx(() {
            final history = controller.history;
            final summary = _HistorySummary.from(history);

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildVerificationCard()),
                SliverToBoxAdapter(child: _buildBuyerTools()),
                SliverToBoxAdapter(child: _buildSummaryRow(summary)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'home_recent_verifications'.tr,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (history.isNotEmpty)
                          Text(
                            'home_total_count'.trParams({'count': '${history.length}'}),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (history.isEmpty)
                  SliverToBoxAdapter(child: _buildEmptyHistory())
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildHistoryCard(history[index]),
                      childCount: history.length,
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = controller.user.value;
    final name = _safeText(user?.name, fallback: 'common_user'.tr);
    final role = _safeText(user?.role, fallback: 'common_buyer'.tr).toUpperCase();
    final email = _safeText(user?.email, fallback: '');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A3D2E), Color(0xFF1A6B4A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'common_brand'.tr,
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildNotificationBell(),
                        const SizedBox(width: 8),
                        _buildIconAction(
                          icon: Icons.folder_outlined,
                          onTap: () => Get.toNamed(Routes.documents),
                        ),
                        const SizedBox(width: 8),
                        _buildIconAction(
                          icon: Icons.workspace_premium_outlined,
                          onTap: () => Get.toNamed(Routes.certificate),
                        ),
                        const SizedBox(width: 8),
                        _buildIconAction(
                          icon: Icons.settings_outlined,
                          onTap: controller.openSettings,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'home_greeting'.tr,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFD4AF37,
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFD4AF37,
                                    ).withValues(alpha: 0.45),
                                  ),
                                ),
                                child: Text(
                                  role,
                                  style: const TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  email,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.55),
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => Get.toNamed(Routes.profile),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 44,
                                      minWidth: 44,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.65),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.person_outline_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'profile_title'.tr,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A3D2E).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: Color(0xFF0A3D2E),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'home_verify_land'.tr,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'home_check_before_buy'.tr,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildStepFlow(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.startVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3D2E),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'home_start_verification'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepFlow() {
    return Row(
      children: [
        Expanded(child: _MiniStep(label: 'home_step_plot'.tr, icon: Icons.description_rounded)),
        Expanded(child: _MiniStep(label: 'home_step_gps'.tr, icon: Icons.my_location_rounded)),
        Expanded(child: _MiniStep(label: 'home_step_nida'.tr, icon: Icons.fingerprint_rounded)),
        Expanded(child: _MiniStep(label: 'home_step_alerts'.tr, icon: Icons.notifications_active_rounded)),
      ],
    );
  }

  Widget _buildBuyerTools() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'buyer_workspace'.tr,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'buyer_workspace_hint'.tr,
            style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _BuyerToolTile(
                  icon: Icons.fact_check_outlined,
                  title: 'buyer_check_docs'.tr,
                  subtitle: 'buyer_check_docs_hint'.tr,
                  onTap: controller.openDocuments,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BuyerToolTile(
                  icon: Icons.handshake_outlined,
                  title: 'buyer_interest'.tr,
                  subtitle: 'buyer_interest_hint'.tr,
                  onTap: controller.openBuyerInterests,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _BuyerToolTile(
                  icon: Icons.fingerprint_rounded,
                  title: 'buyer_certificates'.tr,
                  subtitle: 'buyer_certificates_hint'.tr,
                  onTap: controller.openCertificates,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BuyerToolTile(
                  icon: Icons.notifications_outlined,
                  title: 'seller_alerts'.tr,
                  subtitle: 'buyer_alerts_hint'.tr,
                  onTap: () => Get.toNamed(Routes.notifications),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(_HistorySummary summary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              label: 'home_summary_total'.tr,
              value: '${summary.total}',
              icon: Icons.inventory_2_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryCard(
              label: 'home_summary_safe'.tr,
              value: '${summary.safeCount}',
              icon: Icons.check_circle_outline_rounded,
              accent: const Color(0xFF1A6B4A),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryCard(
              label: 'home_summary_avg_risk'.tr,
              value: '${summary.averageRisk}%',
              icon: Icons.analytics_outlined,
              accent: const Color(0xFFB45309),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
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
                Icons.history_rounded,
                size: 36,
                color: Color(0xFFBDBDBD),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'home_empty_title'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'home_empty_subtitle'.tr,
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

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final risk = _parseRisk(item['risk_score']);
    final verdictText = _safeText(item['verdict'], fallback: '-');
    final type = _safeText(item['type'], fallback: '-');
    final plotRef = _safeText(item['plot_reference'], fallback: '-');
    final displayTime = _formatTimestamp(item['timestamp']);
    final verdict = VerdictStyle.from(
      verdictText: verdictText,
      riskScore: risk,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Get.toNamed(Routes.historyDetail, arguments: item),
          child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plotRef,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatType(type),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: verdict.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(verdict.icon, color: verdict.color, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        verdict.label,
                        style: TextStyle(
                          color: verdict.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'common_risk_score'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$risk / 100',
                      style: TextStyle(
                        fontSize: 12,
                        color: verdict.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: risk / 100,
                    backgroundColor: const Color(0xFFF0F0F0),
                    valueColor: AlwaysStoppedAnimation<Color>(verdict.color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 13,
                  color: Color(0xFFBDBDBD),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    displayTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFBDBDBD),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'history_tap_hint'.tr,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF0A3D2E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }

  Widget _buildIconAction({
    required IconData icon,
    required VoidCallback? onTap,
    bool loading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationBell() {
    final notifController = Get.find<NotificationController>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(Routes.notifications),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Obx(() {
              final count = notifController.unreadCount.value;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  if (count > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD4AF37),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count > 9 ? '9+' : '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  int _parseRisk(dynamic raw) {
    final parsed = int.tryParse(raw?.toString() ?? '') ?? 0;
    return parsed.clamp(0, 100);
  }

  String _safeText(dynamic raw, {required String fallback}) {
    final text = raw?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  String _formatType(String type) {
    switch (type.trim().toLowerCase()) {
      case 'success':
        return 'common_verification_passed'.tr;
      case 'blocked':
        return 'common_verification_blocked'.tr;
      default:
        return type;
    }
  }

  String _formatTimestamp(dynamic raw) {
    final source = raw?.toString().trim() ?? '';
    if (source.isEmpty) {
      return 'common_unknown_time'.tr;
    }

    final parsed = DateTime.tryParse(source);
    if (parsed == null) {
      return source;
    }

    final local = parsed.toLocal();
    final month = _monthName(local.month);
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final suffix = local.hour >= 12 ? 'PM' : 'AM';
    final minute = local.minute.toString().padLeft(2, '0');
    return '$month ${local.day}, ${local.year} - $hour:$minute $suffix';
  }

  String _monthName(int month) {
    const monthKeys = [
      'date_jan',
      'date_feb',
      'date_mar',
      'date_apr',
      'date_may',
      'date_jun',
      'date_jul',
      'date_aug',
      'date_sep',
      'date_oct',
      'date_nov',
      'date_dec',
    ];
    if (month < 1 || month > 12) {
      return 'common_unknown'.tr;
    }
    return monthKeys[month - 1].tr;
  }
}

class _MiniStep extends StatelessWidget {
  const _MiniStep({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF0A3D2E).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF0A3D2E).withValues(alpha: 0.06),
            ),
          ),
          child: Icon(icon, color: const Color(0xFF0A3D2E), size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF757575),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _BuyerToolTile extends StatelessWidget {
  const _BuyerToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 118,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF0A3D2E), size: 22),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    this.accent = const Color(0xFF0A3D2E),
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: accent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySummary {
  const _HistorySummary({
    required this.total,
    required this.safeCount,
    required this.averageRisk,
  });

  final int total;
  final int safeCount;
  final int averageRisk;

  factory _HistorySummary.from(List<Map<String, dynamic>> history) {
    if (history.isEmpty) {
      return const _HistorySummary(total: 0, safeCount: 0, averageRisk: 0);
    }

    var safe = 0;
    var riskSum = 0;

    for (final item in history) {
      final style = VerdictStyle.from(
        verdictText: item['verdict']?.toString(),
        riskScore: int.tryParse(item['risk_score']?.toString() ?? ''),
      );
      if (style.code == 'SAFE') {
        safe += 1;
      }

      final risk = int.tryParse(item['risk_score']?.toString() ?? '') ?? 0;
      riskSum += risk.clamp(0, 100);
    }

    final avg = (riskSum / history.length).round();
    return _HistorySummary(
      total: history.length,
      safeCount: safe,
      averageRisk: avg.clamp(0, 100),
    );
  }
}
