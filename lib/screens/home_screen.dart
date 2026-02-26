import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF1A6B4A),
          onRefresh: controller.loadHomeData,
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
                SliverToBoxAdapter(child: _buildSummaryRow(summary)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Verifications',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (history.isNotEmpty)
                          Text(
                            '${history.length} total',
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
    final name = _safeText(user?.name, fallback: 'User');
    final role = _safeText(user?.role, fallback: 'buyer').toUpperCase();
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
                        const Text(
                          'ANGALIA ARDHI',
                          style: TextStyle(
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
                        _buildIconAction(
                          icon: Icons.settings_outlined,
                          onTap: controller.openSettings,
                        ),
                        const SizedBox(width: 8),
                        _buildIconAction(
                          icon: Icons.logout_rounded,
                          onTap: controller.isLoading.value
                              ? null
                              : controller.logout,
                          loading: controller.isLoading.value,
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
                            'Habari,',
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verify Land',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Check before you buy',
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Start Verification',
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: const [
              _MiniStep(label: 'Plot', icon: Icons.search_rounded),
              _MiniStep(label: 'GPS', icon: Icons.gps_fixed_rounded),
              _MiniStep(label: 'NIDA', icon: Icons.badge_rounded),
              _MiniStep(label: 'AI', icon: Icons.psychology_rounded),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            _MiniStep(label: 'Plot', icon: Icons.search_rounded),
            _StepArrow(),
            _MiniStep(label: 'GPS', icon: Icons.gps_fixed_rounded),
            _StepArrow(),
            _MiniStep(label: 'NIDA', icon: Icons.badge_rounded),
            _StepArrow(),
            _MiniStep(label: 'AI', icon: Icons.psychology_rounded),
          ],
        );
      },
    );
  }

  Widget _buildSummaryRow(_HistorySummary summary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              label: 'Total',
              value: '${summary.total}',
              icon: Icons.inventory_2_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryCard(
              label: 'Safe',
              value: '${summary.safeCount}',
              icon: Icons.check_circle_outline_rounded,
              accent: const Color(0xFF1A6B4A),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryCard(
              label: 'Avg Risk',
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
            const Text(
              'No Verifications Yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your land verification history will appear here.',
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
    final verdictText = _safeText(item['verdict'], fallback: '-').toUpperCase();
    final type = _safeText(item['type'], fallback: '-');
    final plotRef = _safeText(item['plot_reference'], fallback: '-');
    final displayTime = _formatTimestamp(item['timestamp']);
    final verdict = _resolveVerdict(verdictText: verdictText, type: type, risk: risk);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
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
                    const Text(
                      'Risk Score',
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
              ],
            ),
          ],
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
        return 'Verification passed';
      case 'blocked':
        return 'Verification blocked';
      default:
        return type;
    }
  }

  String _formatTimestamp(dynamic raw) {
    final source = raw?.toString().trim() ?? '';
    if (source.isEmpty) {
      return 'Unknown time';
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

  _VerdictStyle _resolveVerdict({
    required String verdictText,
    required String type,
    required int risk,
  }) {
    final normalized = verdictText.toLowerCase();
    final typeNormalized = type.toLowerCase();

    if (normalized.contains('safe') ||
        normalized.contains('pass') ||
        normalized.contains('clear')) {
      return const _VerdictStyle.safe();
    }

    if (normalized.contains('caution') ||
        normalized.contains('review') ||
        normalized.contains('manual')) {
      return const _VerdictStyle.caution();
    }

    if (normalized.contains('block') ||
        normalized.contains('reject') ||
        normalized.contains('fail') ||
        normalized.contains('fraud')) {
      return const _VerdictStyle.blocked();
    }

    if (typeNormalized == 'blocked') {
      return const _VerdictStyle.blocked();
    }

    if (risk <= 30) {
      return const _VerdictStyle.safe();
    }
    if (risk <= 70) {
      return const _VerdictStyle.caution();
    }
    return const _VerdictStyle.blocked();
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month < 1 || month > 12) {
      return 'Unknown';
    }
    return months[month - 1];
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF0A3D2E).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0A3D2E), size: 18),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF9E9E9E),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StepArrow extends StatelessWidget {
  const _StepArrow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 10,
        color: Color(0xFFD4AF37),
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
      final verdict = (item['verdict']?.toString() ?? '').toLowerCase();
      if (verdict.contains('safe') ||
          verdict.contains('pass') ||
          verdict.contains('clear')) {
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

class _VerdictStyle {
  const _VerdictStyle({
    required this.label,
    required this.color,
    required this.background,
    required this.icon,
  });

  const _VerdictStyle.safe()
    : this(
        label: 'SAFE',
        color: const Color(0xFF1A6B4A),
        background: const Color(0xFFECFDF5),
        icon: Icons.check_circle_rounded,
      );

  const _VerdictStyle.caution()
    : this(
        label: 'CAUTION',
        color: const Color(0xFFF59E0B),
        background: const Color(0xFFFFFBEB),
        icon: Icons.warning_rounded,
      );

  const _VerdictStyle.blocked()
    : this(
        label: 'BLOCKED',
        color: const Color(0xFFDC2626),
        background: const Color(0xFFFEF2F2),
        icon: Icons.cancel_rounded,
      );

  final String label;
  final Color color;
  final Color background;
  final IconData icon;
}
