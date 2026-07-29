import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../design/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/ll_ui.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterScreenContent(controller: controller);
  }
}

class RegisterScreenContent extends StatefulWidget {
  const RegisterScreenContent({required this.controller, super.key});

  final AuthController controller;

  @override
  State<RegisterScreenContent> createState() => _RegisterScreenContentState();
}

class _RegisterScreenContentState extends State<RegisterScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
                'register_tagline'.tr,
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              LlTitleBlock(
                title: 'register_title'.tr,
                subtitle: 'register_subtitle'.tr,
              ),
              const SizedBox(height: 40),
              LlSurfaceCard(
                padding: const EdgeInsets.all(28),
                radius: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LlFieldLabel('common_full_name'.tr),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.registerNameController,
                      hint: 'John Doe',
                      icon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    LlFieldLabel('common_email'.tr),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.registerEmailController,
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    LlFieldLabel('register_phone_optional'.tr),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.registerPhoneController,
                      hint: '+255 xxx xxx xxx',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    LlFieldLabel('register_i_am_a'.tr),
                    const SizedBox(height: 8),
                    Obx(() => Row(
                      children: [
                        Expanded(
                          child: _RoleChip(
                            label: 'common_buyer'.tr,
                            icon: Icons.shopping_cart_outlined,
                            selected: widget.controller.selectedRole.value == 'buyer',
                            onTap: () => widget.controller.selectedRole.value = 'buyer',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _RoleChip(
                            label: 'common_seller'.tr,
                            icon: Icons.store_outlined,
                            selected: widget.controller.selectedRole.value == 'seller',
                            onTap: () => widget.controller.selectedRole.value = 'seller',
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 16),
                    LlFieldLabel('common_password'.tr),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.registerPasswordController,
                      hint: '********',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
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
                    const SizedBox(height: 16),
                    LlFieldLabel('register_confirm_password'.tr),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller:
                          widget.controller.registerConfirmPasswordController,
                      hint: '********',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => widget.controller.register(),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                        child: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF9E9E9E),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(() {
                      final error = widget.controller.errorMessage.value;
                      if (error == null) {
                        return const SizedBox.shrink();
                      }
                      return LlErrorBanner(message: error);
                    }),
                    Obx(
                      () => LlPrimaryButton(
                        label: 'register_title'.tr,
                        onPressed: widget.controller.register,
                        isLoading: widget.controller.isLoading.value,
                        icon: Icons.person_add_alt_1_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'register_has_account'.tr,
                    style: TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.login),
                    child: Text(
                      'login_title'.tr,
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

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF0A3D2E).withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF0A3D2E)
                : Colors.grey.withValues(alpha: 0.2),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? const Color(0xFF0A3D2E)
                  : const Color(0xFF9E9E9E),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? const Color(0xFF0A3D2E)
                    : const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
