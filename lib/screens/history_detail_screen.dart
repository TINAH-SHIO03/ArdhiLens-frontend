import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../design/app_colors.dart';
import '../design/verdict_style.dart';
import '../routes/app_routes.dart';
import '../widgets/ll_ui.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = (Get.arguments as Map?)?.cast<String, dynamic>() ?? {};
    final verdict = VerdictStyle.from(
      verdictText: item['verdict']?.toString(),
      riskScore: int.tryParse(item['risk_score']?.toString() ?? ''),
    );
    final risk = int.tryParse(item['risk_score']?.toString() ?? '') ?? 0;
    final plot = item['plot_reference']?.toString() ?? '-';
    final recommendation = item['recommendation']?.toString() ?? '';
    final reasons = (item['reasons'] is List)
        ? (item['reasons'] as List).map((e) => e.toString()).toList()
        : <String>[];
    final name = item['full_name']?.toString() ?? '';
    final nin = item['nin_masked']?.toString() ?? '';
    final timestamp = item['timestamp']?.toString() ?? '';
    final logId = item['verification_log_id']?.toString() ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: const BoxDecoration(
                gradient: AppColors.headerGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LlBackButton(),
                  const SizedBox(height: 14),
                  LlTitleBlock(
                    title: 'history_detail_title'.tr,
                    subtitle: plot,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  children: [
                    LlSurfaceCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: verdict.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(verdict.icon, color: verdict.color, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  verdict.label,
                                  style: TextStyle(
                                    color: verdict.color,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _row('common_risk_score'.tr, '$risk/100'),
                          if (timestamp.isNotEmpty)
                            _row('history_when'.tr, timestamp),
                          if (logId.isNotEmpty)
                            _row('history_log_id'.tr, logId),
                          if (name.isNotEmpty) _row('common_full_name'.tr, name),
                          if (nin.isNotEmpty) _row('result_nin'.tr, nin),
                        ],
                      ),
                    ),
                    if (recommendation.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      LlSurfaceCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'result_recommendation'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recommendation,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (reasons.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      LlSurfaceCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'result_reasons'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...reasons.map(
                              (reason) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: verdict.color,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        reason,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    LlPrimaryButton(
                      label: 'result_start_new'.tr,
                      onPressed: () => Get.offAllNamed(Routes.home),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
