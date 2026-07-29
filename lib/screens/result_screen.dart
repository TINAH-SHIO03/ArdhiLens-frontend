import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/certificate_controller.dart';
import '../controllers/result_controller.dart';
import '../design/verdict_style.dart';
import '../models/owner_link_failure_result.dart';
import '../models/verification_certificate.dart';
import '../models/verification_result.dart';
import '../models/verification_steps.dart';
import '../routes/app_routes.dart';

class ResultScreen extends GetView<ResultController> {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResultScreenContent(controller: controller);
  }
}

class ResultScreenContent extends StatefulWidget {
  final ResultController controller;

  const ResultScreenContent({required this.controller, super.key});

  @override
  State<ResultScreenContent> createState() => _ResultScreenContentState();
}

class _ResultScreenContentState extends State<ResultScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      body: Obx(() {
        final outcome = widget.controller.outcome.value;

        if (outcome == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(height: 16),
                Text(
                  'result_loading'.tr,
                  style: TextStyle(
                    color: const Color(0xFF9E9E9E),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        if (outcome.isSuccess) {
          return _successView(outcome.success!);
        }

        return _blockedView(outcome.failure!);
      }),
    );
  }

  Widget _successView(VerificationResult result) {
    final passportUrl = widget.controller.passportImageUrl();
    final nidaPassed = result.steps.nidaQuestionsPassed;
    final hasIdentity = result.identity.fullName != null;

    return Stack(
      children: [
        // Header gradient
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 180,
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
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Back button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Success badge
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: nidaPassed
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: nidaPassed
                                ? Colors.green.shade200
                                : Colors.orange.shade200,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          nidaPassed
                              ? Icons.check_circle_rounded
                              : Icons.info_rounded,
                          color: nidaPassed
                              ? Colors.green.shade600
                              : Colors.orange.shade600,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Center(
                      child: Text(
                        nidaPassed ? 'result_passed'.tr : 'result_completed'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Verification Steps Card
                    _buildStepsCard(result),

                    const SizedBox(height: 20),

                    // Identity card (only if NIDA passed)
                    if (hasIdentity) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_rounded,
                                  color: Color(0xFF1A6B4A),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'result_identity_info'.tr,
                                  style: TextStyle(
                                    color: Color(0xFF424242),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _identityRow(
                              'common_full_name'.tr,
                              result.identity.fullName ?? '-',
                            ),
                            const SizedBox(height: 12),
                            _identityRow('result_gender'.tr, result.identity.gender ?? '-'),
                            const SizedBox(height: 12),
                            _identityRow('result_nin'.tr, result.identity.ninMasked ?? '-'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ] else ...[
                      // NIDA failed notice
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'result_nida_failed'.tr,
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Passport image if available
                    if (passportUrl != null && passportUrl.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.image_rounded,
                                  color: Color(0xFF1A6B4A),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'result_id_photo'.tr,
                                  style: TextStyle(
                                    color: Color(0xFF424242),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                passportUrl,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'result_image_unavailable'.tr,
                                        style: TextStyle(
                                          color: Color(0xFF9E9E9E),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Assessment card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.analytics_rounded,
                                color: Color(0xFF1A6B4A),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'result_risk_assessment'.tr,
                                style: TextStyle(
                                  color: Color(0xFF424242),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Verdict badge
                          Builder(
                            builder: (_) {
                              final style = VerdictStyle.from(
                                verdictText: result.assessment.verdict,
                                riskScore: result.assessment.riskScore,
                              );
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: style.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: style.color.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(style.icon, color: style.color, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      style.label,
                                      style: TextStyle(
                                        color: style.color,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Risk score
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'common_risk_score'.tr,
                                style: TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${result.assessment.riskScore}%',
                                style: TextStyle(
                                  color: _riskScoreColor(result.assessment.riskScore),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: result.assessment.riskScore / 100,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFE0E0E0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _riskScoreColor(result.assessment.riskScore),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'result_recommendation'.tr,
                            style: TextStyle(
                              color: Color(0xFF424242),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.assessment.recommendation,
                            style: const TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                          if (result.assessment.reasons.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'result_reasons'.tr,
                              style: TextStyle(
                                color: Color(0xFF424242),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...result.assessment.reasons.map(
                              (reason) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      result.steps.nidaQuestionsPassed
                                          ? Icons.check_rounded
                                          : Icons.info_outline_rounded,
                                      color: result.steps.nidaQuestionsPassed
                                          ? const Color(0xFF1A6B4A)
                                          : Colors.orange.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        reason,
                                        style: const TextStyle(
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 13,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Certificate card
                    Obx(() {
                      final current = widget.controller.outcome.value?.success;
                      if (current == null) {
                        return const SizedBox.shrink();
                      }
                      if (current.certificate != null &&
                          current.assessment.verdict != 'DO_NOT_BUY') {
                        return Column(
                          children: [
                            _buildCertificateCard(current.certificate!),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      final eligible = current.certificateEligible ||
                          (current.steps.nidaQuestionsPassed &&
                              (current.assessment.verdict == 'SAFE' ||
                                  current.assessment.verdict == 'CAUTION'));
                      if (!eligible) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          _buildMissingCertificateCard(current),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),

                    if (result.assessment.verdict != 'DO_NOT_BUY') ...[
                      _buildInterestCard(result),
                      const SizedBox(height: 20),
                    ],

                    // AI Assistant button
                    _buildAssistantButton(),

                    const SizedBox(height: 20),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: widget.controller.startNew,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3D2E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'result_start_new'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepsCard(VerificationResult result) {
    final steps = result.steps;
    final isSellerMode = result.verificationMode == 'seller_ownership';
    final showOwnerHint = !steps.ownerLinkPassed;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Text(
            'result_steps'.tr,
            style: TextStyle(
              color: Color(0xFF424242),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _stepRow('result_step_plot_found'.tr, steps.plotFound),
          _stepRow('result_step_gps'.tr, steps.gpsPassed),
          _stepRow('result_step_nida'.tr, steps.nidaQuestionsPassed),
          _stepRow('result_step_owner'.tr, steps.ownerLinkPassed),
          if (showOwnerHint) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: Color(0xFF0369A1),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isSellerMode
                          ? 'result_owner_link_seller_hint'.tr
                          : 'result_owner_link_buyer_hint'.tr,
                      style: const TextStyle(
                        color: Color(0xFF0C4A6E),
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _stepRow(String label, bool passed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: passed ? const Color(0xFF1A6B4A) : Colors.red.shade400,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: passed ? const Color(0xFF212121) : const Color(0xFF9E9E9E),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: passed ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              passed ? 'common_pass'.tr : 'common_fail'.tr,
              style: TextStyle(
                color: passed ? const Color(0xFF1A6B4A) : Colors.red.shade600,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(VerificationCertificateSummary cert) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                cert.certificateTitle?.isNotEmpty == true
                    ? cert.certificateTitle!
                    : (cert.isSellerOwnership
                        ? 'cert_type_seller'.tr
                        : 'result_certificate'.tr),
                style: TextStyle(
                  color: Color(0xFF424242),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _identityRow('result_cert_number'.tr, cert.certificateNumber),
          if (cert.issuedAt != null) ...[
            const SizedBox(height: 10),
            _identityRow('result_issued'.tr, _formatDate(cert.issuedAt!)),
          ],
          if ((cert.fingerprint ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            _identityRow(
              'result_fingerprint'.tr,
              '${cert.fingerprint!.substring(0, cert.fingerprint!.length > 16 ? 16 : cert.fingerprint!.length)}…',
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final certCtrl = Get.find<CertificateController>();
                      await certCtrl.viewCertificate(
                        VerificationCertificate(
                          id: cert.id,
                          certificateNumber: cert.certificateNumber,
                          verificationLogId: 0,
                          plotReference: '',
                          verdict: '',
                          issuedAt: cert.issuedAt,
                          fingerprint: cert.fingerprint,
                          certificateType: cert.certificateType,
                          certificateTitle: cert.certificateTitle,
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const SizedBox.shrink(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0A3D2E),
                      side: const BorderSide(color: Color(0xFF0A3D2E), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final certCtrl = Get.find<CertificateController>();
                      await certCtrl.downloadCertificate(
                        VerificationCertificate(
                          id: cert.id,
                          certificateNumber: cert.certificateNumber,
                          verificationLogId: 0,
                          plotReference: '',
                          verdict: '',
                          issuedAt: cert.issuedAt,
                          fingerprint: cert.fingerprint,
                          certificateType: cert.certificateType,
                          certificateTitle: cert.certificateTitle,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: Text(
                      'cert_download'.tr,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3D2E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'cert_email_copy_hint'.tr,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingCertificateCard(VerificationResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'result_certificate_missing'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.certificateError ?? 'result_certificate_missing_hint'.tr,
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: widget.controller.isRecoveringCertificate.value
                  ? null
                  : widget.controller.recoverCertificate,
              icon: widget.controller.isRecoveringCertificate.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.fingerprint_rounded, size: 16),
              label: Text('result_generate_certificate'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3D2E),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestCard(VerificationResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'result_interest_title'.tr,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            'result_interest_hint'.tr,
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: widget.controller.isSendingInterest.value
                  ? null
                  : widget.controller.expressInterest,
              icon: const Icon(Icons.handshake_outlined, size: 16),
              label: Text('result_interest_cta'.tr),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0A3D2E),
                side: const BorderSide(color: Color(0xFF0A3D2E), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    final local = parsed.toLocal();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[local.month - 1]} ${local.day}, ${local.year}';
  }

  Color _riskScoreColor(int score) {
    if (score <= 30) return const Color(0xFF16A34A);
    if (score <= 60) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  Widget _blockedView(OwnerLinkFailureResult blocked) {
    return Stack(
      children: [
        // Header gradient
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 180,
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
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Back button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Blocked badge
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red.shade200,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.block_rounded,
                          color: Colors.red.shade600,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Center(
                      child: Text(
                        'result_blocked'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Block reason card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.red.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: Colors.red.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  blocked.message,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _ownerLinkRow(
                            'result_owner_link'.tr,
                            blocked.ownerLink.passed
                                ? 'result_yes'.tr
                                : 'result_no'.tr,
                            blocked.ownerLink.passed,
                          ),
                          const SizedBox(height: 8),
                          _ownerLinkRow(
                            'result_plot_owner_match'.tr,
                            blocked.ownerLink.plotOwnerMatch
                                ? 'result_yes'.tr
                                : 'result_no'.tr,
                            blocked.ownerLink.plotOwnerMatch,
                          ),
                          const SizedBox(height: 8),
                          _ownerLinkRow(
                            'result_history_match'.tr,
                            blocked.ownerLink.historyOwnerMatch
                                ? 'result_yes'.tr
                                : 'result_no'.tr,
                            blocked.ownerLink.historyOwnerMatch,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Assessment card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics_rounded,
                                color: Colors.red.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'result_risk_assessment'.tr,
                                style: TextStyle(
                                  color: Color(0xFF424242),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Builder(
                            builder: (_) {
                              final style = VerdictStyle.from(
                                verdictText: blocked.assessment.verdict,
                                riskScore: blocked.assessment.riskScore,
                              );
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: style.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: style.color.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(style.icon, color: style.color, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      style.label,
                                      style: TextStyle(
                                        color: style.color,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'common_risk_score'.tr,
                                style: TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${blocked.assessment.riskScore}%',
                                style: const TextStyle(
                                  color: Color(0xFF212121),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: blocked.assessment.riskScore / 100,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFE0E0E0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red.shade400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'result_recommendation'.tr,
                            style: TextStyle(
                              color: const Color(0xFF424242),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            blocked.assessment.recommendation,
                            style: const TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                          if (blocked.assessment.reasons.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'result_block_reasons'.tr,
                              style: TextStyle(
                                color: const Color(0xFF424242),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...blocked.assessment.reasons.map(
                              (reason) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.close_rounded,
                                      color: Colors.red.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        reason,
                                        style: const TextStyle(
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 13,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // AI Assistant button
                    _buildAssistantButton(),

                    const SizedBox(height: 20),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: widget.controller.startNew,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3D2E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'result_start_new'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssistantButton() {
    return Obx(() {
      final canUseAssistant = widget.controller.canOpenAssistant;
      final activeLogId = widget.controller.activeVerificationLogId;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.support_agent_rounded,
                  color: const Color(0xFF1A6B4A),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'result_assistant'.tr,
                    style: TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'result_assistant_desc'.tr,
              style: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              activeLogId > 0
                  ? 'result_ref_log'.trParams({'id': '$activeLogId'})
                  : 'result_assistant_unavailable'.tr,
              style: TextStyle(
                color: activeLogId > 0
                    ? const Color(0xFF9E9E9E)
                    : Colors.red.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: canUseAssistant
                    ? () => Get.toNamed(Routes.chat)
                    : null,
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: Text(
                  'result_open_chat'.tr,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6B4A),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _identityRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _ownerLinkRow(String label, String value, bool passed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.red.shade700,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: passed ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: passed ? Colors.green.shade200 : Colors.red.shade200,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: passed ? Colors.green.shade700 : Colors.red.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
