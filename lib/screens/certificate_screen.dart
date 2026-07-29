import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/certificate_controller.dart';
import '../models/verification_certificate.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  CertificateController get controller => Get.find<CertificateController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCertificates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      appBar: AppBar(
        title: Text(
          'cert_title'.tr,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF0A3D2E),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF1A6B4A),
          onRefresh: controller.fetchCertificates,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF1A6B4A),
                ),
              );
            }

            final certificates = controller.certificates;

            if (certificates.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: const [
                  SizedBox(height: 120),
                  _EmptyState(),
                ],
              );
            }

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Certificates',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          '${certificates.length} total',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _CertificateCard(certificate: certificates[index]),
                    childCount: certificates.length,
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
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.certificate});

  final VerificationCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final verdict = _resolveVerdict(certificate.verdict);
    final risk = (certificate.riskScore ?? 0).clamp(0, 100);
    final expired = certificate.isExpired;
    final controller = Get.find<CertificateController>();

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
                        certificate.certificateTitle?.isNotEmpty == true
                            ? certificate.certificateTitle!
                            : (certificate.isSellerOwnership
                                ? 'cert_type_seller'.tr
                                : 'cert_type_buyer'.tr),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0A3D2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        certificate.certificateNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: 0.5,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Plot: ${certificate.plotReference}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
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
                    if (expired) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'EXPIRED',
                          style: TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ],
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
                  Icons.calendar_today_rounded,
                  size: 13,
                  color: Color(0xFFBDBDBD),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _formatDate(certificate.issuedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFBDBDBD),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: Obx(() {
                      final viewing =
                          controller.viewingId.value == certificate.id;
                      return OutlinedButton.icon(
                        onPressed: expired || viewing
                            ? null
                            : () => controller.viewCertificate(certificate),
                        icon: viewing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.visibility_outlined, size: 18),
                        label: const SizedBox.shrink(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0A3D2E),
                          side: const BorderSide(color: Color(0xFF0A3D2E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: Obx(() {
                      final downloading =
                          controller.downloadingId.value == certificate.id;
                      return ElevatedButton.icon(
                        onPressed: expired || downloading
                            ? null
                            : () => controller.downloadCertificate(certificate),
                        icon: downloading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.download_rounded, size: 18),
                        label: Text(
                          downloading ? 'cert_downloading'.tr : 'cert_download'.tr,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3D2E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? raw) {
    final source = raw?.trim() ?? '';
    if (source.isEmpty) return 'common_na'.tr;

    final parsed = DateTime.tryParse(source);
    if (parsed == null) return source;

    final local = parsed.toLocal();
    final months = [
      'date_jan'.tr,
      'date_feb'.tr,
      'date_mar'.tr,
      'date_apr'.tr,
      'date_may'.tr,
      'date_jun'.tr,
      'date_jul'.tr,
      'date_aug'.tr,
      'date_sep'.tr,
      'date_oct'.tr,
      'date_nov'.tr,
      'date_dec'.tr,
    ];
    return '${months[local.month - 1]} ${local.day}, ${local.year}';
  }

  _VerdictStyle _resolveVerdict(String verdictText) {
    final normalized = verdictText.toLowerCase();

    if (normalized.contains('safe') ||
        normalized.contains('salama') ||
        normalized.contains('pass') ||
        normalized.contains('clear')) {
      return _VerdictStyle.safe();
    }

    if (normalized.contains('caution') ||
        normalized.contains('tahadhari') ||
        normalized.contains('review') ||
        normalized.contains('manual')) {
      return _VerdictStyle.caution();
    }

    return _VerdictStyle.blocked();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
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
                Icons.verified_outlined,
                size: 36,
                color: Color(0xFFBDBDBD),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'cert_empty_title'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'cert_empty_desc'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
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

class _VerdictStyle {
  _VerdictStyle({
    required this.label,
    required this.color,
    required this.background,
    required this.icon,
  });

  factory _VerdictStyle.safe() => _VerdictStyle(
        label: 'verdict_safe'.tr,
        color: const Color(0xFF1A6B4A),
        background: const Color(0xFFECFDF5),
        icon: Icons.check_circle_rounded,
      );

  factory _VerdictStyle.caution() => _VerdictStyle(
        label: 'verdict_caution'.tr,
        color: const Color(0xFFF59E0B),
        background: const Color(0xFFFFFBEB),
        icon: Icons.warning_rounded,
      );

  factory _VerdictStyle.blocked() => _VerdictStyle(
        label: 'verdict_do_not_buy'.tr,
        color: const Color(0xFFDC2626),
        background: const Color(0xFFFEF2F2),
        icon: Icons.cancel_rounded,
      );

  final String label;
  final Color color;
  final Color background;
  final IconData icon;
}
