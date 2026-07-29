import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/seller_home_controller.dart';
import '../design/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/ll_ui.dart';

class SellerHomeScreen extends GetView<SellerHomeController> {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final user = controller.user.value;
          return RefreshIndicator(
            onRefresh: controller.refreshDashboard,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                _header(user),
                const SizedBox(height: 16),
                if (controller.errorMessage.value != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      controller.errorMessage.value!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                _plotLinkBanner(),
                const SizedBox(height: 14),
                _kycCard(),
                const SizedBox(height: 14),
                _ownershipProofCard(),
                const SizedBox(height: 14),
                _quickActions(),
                const SizedBox(height: 18),
                _buyerRequestsSection(),
                const SizedBox(height: 18),
                _recentChecksSection(),
                const SizedBox(height: 18),
                _plotsSection(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _header(dynamic user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'seller_home_brand'.tr,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user?.name ?? 'common_user'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'seller_home_subtitle'.tr,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed(Routes.profile),
                icon: const Icon(Icons.person_outline, color: Colors.white, size: 16),
                label: Text(
                  'profile_title'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _plotLinkBanner() {
    final linked = controller.plotLinkStatus.value == 'linked';
    return LlSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            linked ? Icons.link_rounded : Icons.link_off_rounded,
            color: linked ? const Color(0xFF1A6B4A) : Colors.orange.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'seller_plot_link_title'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.plotLinkMessage.value.isNotEmpty
                      ? controller.plotLinkMessage.value
                      : 'seller_plot_link_hint'.tr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${controller.linkedPlotCount.value}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0A3D2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kycCard() {
    final status = controller.kycStatus.value;
    final submitted = status != 'none';
    final statusLabel = _kycStatusLabel(status);

    return LlSurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'seller_kyc_title'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
              if (submitted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'verified'
                        ? const Color(0xFFE8F5EE)
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: status == 'verified'
                          ? const Color(0xFF1A6B4A)
                          : Colors.orange.shade900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            submitted ? 'seller_kyc_submitted_note'.tr : 'seller_kyc_explainer'.tr,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
          if (submitted && controller.user.value?.nin != null) ...[
            const SizedBox(height: 12),
            Text(
              'seller_kyc_nin_linked'.trParams({
                'nin': controller.user.value!.nin!,
              }),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
          if (!submitted) ...[
            const SizedBox(height: 12),
            LlInputField(
              controller: controller.ninController,
              hint: '19901215-25555-00001',
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 12),
            LlPrimaryButton(
              label: 'seller_kyc_submit'.tr,
              onPressed: controller.submitKyc,
              isLoading: controller.isLoading.value,
              icon: Icons.verified_user_outlined,
            ),
          ] else if (status == 'needs_manual_review') ...[
            const SizedBox(height: 12),
            LlInputField(
              controller: controller.ninController,
              hint: '19901215-25555-00001',
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 12),
            LlPrimaryButton(
              label: 'seller_kyc_resubmit'.tr,
              onPressed: controller.submitKyc,
              isLoading: controller.isLoading.value,
              icon: Icons.refresh_rounded,
            ),
          ],
        ],
      ),
    );
  }

  String _kycStatusLabel(String status) {
    return switch (status) {
      'verified' => 'seller_kyc_status_verified'.tr,
      'pending_review' => 'seller_kyc_status_pending'.tr,
      'needs_manual_review' => 'seller_kyc_status_review'.tr,
      _ => status,
    };
  }

  Widget _ownershipProofCard() {
    return LlSurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'seller_ownership_proof'.tr,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            'seller_ownership_proof_hint'.tr,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 14),
          LlPrimaryButton(
            label: 'seller_start_ownership_proof'.tr,
            onPressed: controller.startOwnershipProof,
            icon: Icons.verified_outlined,
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: Icons.notifications_outlined,
            label: 'seller_alerts'.tr,
            badge: controller.unread.value,
            onTap: () => Get.toNamed(Routes.notifications),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            icon: Icons.folder_outlined,
            label: 'seller_ownership_docs'.tr,
            onTap: controller.openDocuments,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            icon: Icons.workspace_premium_outlined,
            label: 'seller_attestations'.tr,
            onTap: controller.openCertificates,
          ),
        ),
      ],
    );
  }

  Widget _buyerRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'seller_buyers_title'.tr,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
            if (controller.pendingInterestCount.value > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${controller.pendingInterestCount.value} ${'seller_action_needed'.tr}',
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'seller_buyers_subtitle'.tr,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),
        if (controller.isLoadingInterests.value)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else if (controller.buyerInterests.isEmpty)
          LlSurfaceCard(
            padding: const EdgeInsets.all(24),
            child: Text('seller_no_buyers'.tr),
          )
        else
          ...controller.buyerInterests.map((interest) {
            final buyer = interest['buyer'] as Map?;
            final id = int.tryParse('${interest['id']}') ?? 0;
            final status = interest['status']?.toString() ?? 'pending';
            final statusLabel = interest['status_label']?.toString() ?? status;
            final actionRequired = interest['action_required'] == true;
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
                            buyer?['name']?.toString() ?? 'common_buyer'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (actionRequired)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'seller_action_needed'.tr,
                              style: TextStyle(
                                color: Colors.orange.shade900,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      interest['plot_reference']?.toString() ?? '-',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: actionRequired
                            ? Colors.orange.shade800
                            : const Color(0xFF0A3D2E),
                      ),
                    ),
                    if ((interest['buyer_message']?.toString() ?? '')
                        .isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(interest['buyer_message'].toString()),
                    ],
                    if (status == 'pending') ...[
                      const SizedBox(height: 10),
                      LlInputField(
                        controller: controller.replyController,
                        hint: 'seller_reply_hint'.tr,
                        icon: Icons.reply_outlined,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: controller.respondingId.value == id
                                  ? null
                                  : () => controller.respondToInterest(
                                        id,
                                        'declined',
                                      ),
                              child: Text('seller_decline'.tr),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controller.respondingId.value == id
                                  ? null
                                  : () => controller.respondToInterest(
                                        id,
                                        'accepted',
                                      ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A3D2E),
                                foregroundColor: Colors.white,
                              ),
                              child: Text('seller_accept'.tr),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _recentChecksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'seller_recent_checks'.tr,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 10),
        if (controller.isLoadingVerifications.value)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else if (controller.recentVerifications.isEmpty)
          LlSurfaceCard(
            padding: const EdgeInsets.all(24),
            child: Text('seller_no_checks'.tr),
          )
        else
          ...controller.recentVerifications.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LlSurfaceCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['buyer_name']?.toString() ?? 'common_buyer'.tr,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item['plot_reference'] ?? '-'} · ${item['verdict'] ?? '-'}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _plotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'seller_my_plots'.tr,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 10),
        if (controller.plots.isEmpty)
          LlSurfaceCard(
            padding: const EdgeInsets.all(24),
            child: Text('seller_no_plots'.tr),
          )
        else
          ...controller.plots.map(
            (plot) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LlSurfaceCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plot['plot_reference']?.toString() ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${plot['ward'] ?? ''} ${plot['district'] ?? ''} ${plot['region'] ?? ''}'
                          .trim(),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 88,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.brand),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (badge > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD4AF37),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$badge',
                      style: const TextStyle(fontSize: 9, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
