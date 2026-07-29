import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../design/app_colors.dart';
import '../widgets/ll_ui.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.user.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadProfile(force: true),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                const LlBackButton(),
                const SizedBox(height: 16),
                Text(
                  'profile_title'.tr,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'profile_subtitle'.tr,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.brand.withValues(alpha: 0.15),
                        backgroundImage: controller.avatarBytes.value != null
                            ? MemoryImage(controller.avatarBytes.value!)
                            : null,
                        child: controller.avatarBytes.value == null
                            ? Text(
                                (controller.user.value?.name.isNotEmpty == true
                                        ? controller.user.value!.name[0]
                                        : '?')
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.brand,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Material(
                          color: AppColors.brand,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: controller.isUploadingAvatar.value
                                ? null
                                : controller.pickAndUploadAvatar,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: controller.isUploadingAvatar.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    controller.user.value?.role.toUpperCase() ?? '',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                if (controller.errorMessage.value != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value!,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ],
                const SizedBox(height: 24),
                LlSurfaceCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LlFieldLabel('common_name'.tr),
                      const SizedBox(height: 8),
                      LlInputField(
                        controller: controller.nameController,
                        hint: 'common_name'.tr,
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      LlFieldLabel('common_email'.tr),
                      const SizedBox(height: 8),
                      LlInputField(
                        controller: controller.emailController,
                        hint: 'common_email'.tr,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      LlFieldLabel('common_phone'.tr),
                      const SizedBox(height: 8),
                      LlInputField(
                        controller: controller.phoneController,
                        hint: 'common_phone'.tr,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 18),
                      Obx(
                        () => LlPrimaryButton(
                          label: 'profile_save'.tr,
                          onPressed: controller.saveProfile,
                          isLoading: controller.isSaving.value,
                          icon: Icons.check_circle_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LlSurfaceCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.settings_outlined,
                            color: AppColors.brand),
                        title: Text('settings_title'.tr),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Get.toNamed('/settings'),
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.logout_rounded,
                            color: AppColors.danger),
                        title: Text(
                          'home_logout'.tr,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () async {
                          final confirm = await Get.dialog<bool>(
                            AlertDialog(
                              title: Text('home_logout_title'.tr),
                              content: Text('home_logout_confirm'.tr),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(result: false),
                                  child: Text('common_cancel'.tr),
                                ),
                                TextButton(
                                  onPressed: () => Get.back(result: true),
                                  child: Text('home_logout'.tr),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await controller.logout();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
