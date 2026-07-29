import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../core/app_config.dart';
import '../design/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/ll_ui.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            const LlBackButton(),
            const SizedBox(height: 16),
            Text(
              'settings_title'.tr,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'settings_subtitle_new'.tr,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            LlSurfaceCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded,
                          color: AppColors.brand),
                      const SizedBox(width: 10),
                      Text(
                        'profile_title'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'settings_profile_hint'.tr,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Get.toNamed(Routes.profile),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text('settings_open_profile'.tr),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LlSurfaceCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language_rounded, color: AppColors.brand),
                      const SizedBox(width: 10),
                      Text(
                        'settings_language'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedLanguage.value,
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(
                          value: 'sw',
                          child: Text('Kiswahili'),
                        ),
                      ],
                      onChanged: controller.setLanguage,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.translate_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LlSurfaceCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_done_outlined,
                          color: AppColors.brand),
                      const SizedBox(width: 10),
                      Text(
                        'settings_connection'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'settings_live_api'.tr,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppConfig.apiBaseUrl,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => LlPrimaryButton(
                label: 'home_logout'.tr,
                onPressed: () async {
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
                isLoading: controller.isLoading.value,
                icon: Icons.logout_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
