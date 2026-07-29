import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../design/app_colors.dart';
import '../widgets/ll_ui.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ForgotPasswordBody();
  }
}

class _ForgotPasswordBody extends StatefulWidget {
  const _ForgotPasswordBody();

  @override
  State<_ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<_ForgotPasswordBody> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final step = 0.obs;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  AuthController get controller => Get.find<AuthController>();

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LlHeaderShell(
      headerHeight: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const LlBackButton(),
          const SizedBox(height: 20),
          LlTitleBlock(
            title: 'auth_forgot_title'.tr,
            subtitle: 'auth_forgot_subtitle'.tr,
          ),
          const SizedBox(height: 28),
          Obx(() {
            return LlSurfaceCard(
              padding: const EdgeInsets.all(22),
              radius: 22,
              child: step.value == 0 ? _buildEmailStep() : _buildResetStep(),
            );
          }),
          Obx(() {
            final err = controller.errorMessage.value;
            if (err == null || err.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 14),
              child: LlErrorBanner(message: err),
            );
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth_forgot_step1'.tr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'auth_forgot_step1_hint'.tr,
          style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 18),
        LlFieldLabel('common_email'.tr),
        const SizedBox(height: 8),
        LlInputField(
          controller: emailController,
          hint: 'you@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        Obx(
          () => LlPrimaryButton(
            label: 'auth_send_code'.tr,
            isLoading: controller.isLoading.value,
            icon: Icons.mark_email_read_outlined,
            onPressed: () async {
              await controller.requestPasswordReset(emailController.text.trim());
              if (controller.errorMessage.value == null) {
                final debugCode = controller.lastResetDebugCode.value;
                if (debugCode != null && debugCode.isNotEmpty) {
                  codeController.text = debugCode;
                }
                step.value = 1;
                Get.snackbar(
                  'auth_send_code'.tr,
                  debugCode != null && debugCode.isNotEmpty
                      ? 'auth_code_onscreen'.trParams({'code': debugCode})
                      : 'auth_code_sent'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.brand,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 6),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth_forgot_step2'.tr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'auth_forgot_step2_hint'.tr,
          style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 18),
        Obx(() {
          final debugCode = controller.lastResetDebugCode.value;
          if (debugCode == null || debugCode.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDBA74)),
            ),
            child: Text(
              'auth_code_onscreen'.trParams({'code': debugCode}),
              style: const TextStyle(
                color: Color(0xFF9A3412),
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }),
        LlFieldLabel('auth_otp_code'.tr),
        const SizedBox(height: 8),
        LlInputField(
          controller: codeController,
          hint: '123456',
          icon: Icons.pin_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        LlFieldLabel('common_password'.tr),
        const SizedBox(height: 8),
        LlInputField(
          controller: passwordController,
          hint: '********',
          icon: Icons.lock_outline,
          obscureText: obscurePassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => obscurePassword = !obscurePassword),
            child: Icon(
              obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF9E9E9E),
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 14),
        LlFieldLabel('register_confirm_password'.tr),
        const SizedBox(height: 8),
        LlInputField(
          controller: confirmController,
          hint: '********',
          icon: Icons.lock_outline,
          obscureText: obscureConfirm,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => obscureConfirm = !obscureConfirm),
            child: Icon(
              obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF9E9E9E),
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => LlPrimaryButton(
            label: 'auth_reset_password'.tr,
            isLoading: controller.isLoading.value,
            icon: Icons.check_circle_outline,
            onPressed: () async {
              await controller.resetPassword(
                email: emailController.text.trim(),
                code: codeController.text.trim(),
                password: passwordController.text.trim(),
                confirm: confirmController.text.trim(),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => step.value = 0,
          child: Text(
            'auth_back_to_email'.tr,
            style: const TextStyle(
              color: AppColors.brand,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
