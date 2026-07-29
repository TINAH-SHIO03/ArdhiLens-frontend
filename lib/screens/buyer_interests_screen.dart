import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/buyer_interest_controller.dart';
import '../design/app_colors.dart';
import '../widgets/ll_ui.dart';

class BuyerInterestsScreen extends GetView<BuyerInterestController> {
  const BuyerInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('interest_title'.tr),
        backgroundColor: const Color(0xFF0A3D2E),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.loadInterests,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              LlSurfaceCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'interest_express'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'interest_express_hint'.tr,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    LlInputField(
                      controller: controller.plotController,
                      hint: 'Plot reference e.g. DSM-KIN-001',
                      icon: Icons.map_outlined,
                    ),
                    const SizedBox(height: 10),
                    LlInputField(
                      controller: controller.messageController,
                      hint: 'interest_message_hint'.tr,
                      icon: Icons.message_outlined,
                    ),
                    const SizedBox(height: 12),
                    if (controller.errorMessage.value != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          controller.errorMessage.value!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    LlPrimaryButton(
                      label: 'interest_send'.tr,
                      onPressed: controller.submitInterest,
                      isLoading: controller.isSubmitting.value,
                      icon: Icons.send_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'interest_my_requests'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              if (controller.isLoading.value && controller.interests.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (controller.interests.isEmpty)
                LlSurfaceCard(
                  padding: const EdgeInsets.all(24),
                  child: Text('interest_empty_buyer'.tr),
                )
              else
                ...controller.interests.map((item) {
                  final status = item['status']?.toString() ?? 'pending';
                  final statusLabel =
                      item['status_label']?.toString() ?? status;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LlSurfaceCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['plot_reference']?.toString() ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              _StatusChip(status: status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            statusLabel,
                            style: const TextStyle(
                              color: Color(0xFF0A3D2E),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          if ((item['buyer_message']?.toString() ?? '')
                              .isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(item['buyer_message'].toString()),
                          ],
                          if ((item['seller_reply']?.toString() ?? '')
                              .isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              '${'interest_seller_reply'.tr}: ${item['seller_reply']}',
                              style: const TextStyle(
                                color: Color(0xFF0A3D2E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          if (item['seller'] != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              '${'interest_seller'.tr}: ${(item['seller'] as Map)['name'] ?? '-'}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      }),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'accepted':
        color = const Color(0xFF1A6B4A);
      case 'declined':
        color = Colors.red.shade600;
      case 'contacted':
        color = const Color(0xFFB45309);
      default:
        color = const Color(0xFF64748B);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
