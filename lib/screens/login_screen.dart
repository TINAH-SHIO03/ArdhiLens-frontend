import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../design/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/ll_ui.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreenContent(controller: controller);
  }
}

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({required this.controller, super.key});

  final AuthController controller;

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LlHeaderShell(
      headerHeight: 260,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const LlBackButton(),
              const SizedBox(height: 24),
              Text(
                'login_welcome_back'.tr,
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              LlTitleBlock(
                title: 'login_title'.tr,
                subtitle: 'login_subtitle'.tr,
              ),
              const SizedBox(height: 52),
              LlSurfaceCard(
                padding: const EdgeInsets.all(28),
                radius: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LlFieldLabel('common_email'.tr),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.loginEmailController,
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    LlFieldLabel('common_password'.tr),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.loginPasswordController,
                      hint: '********',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => widget.controller.login(),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF9E9E9E),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.toNamed(Routes.forgotPassword),
                        child: Text(
                          'login_forgot_password'.tr,
                          style: TextStyle(
                            color: AppColors.brand,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Obx(() {
                      final error = widget.controller.errorMessage.value;
                      if (error == null) {
                        return const SizedBox.shrink();
                      }
                      return LlErrorBanner(message: error);
                    }),
                    Obx(
                      () => LlPrimaryButton(
                        label: 'login_title'.tr,
                        onPressed: widget.controller.login,
                        isLoading: widget.controller.isLoading.value,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'login_no_account'.tr,
                    style: TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.register),
                    child: Text(
                      'login_register'.tr,
                      style: TextStyle(
                        color: AppColors.brand,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
