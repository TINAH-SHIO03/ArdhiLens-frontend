import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/nin_controller.dart';
import '../design/app_colors.dart';
import '../widgets/ll_ui.dart';

class NinScreen extends GetView<NinController> {
  const NinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NinScreenContent(controller: controller);
  }
}

class NinScreenContent extends StatefulWidget {
  const NinScreenContent({required this.controller, super.key});

  final NinController controller;

  @override
  State<NinScreenContent> createState() => _NinScreenContentState();
}

class _NinScreenContentState extends State<NinScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
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
      headerHeight: 210,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const LlBackButton(),
              const SizedBox(height: 24),
              LlStepBadge(label: 'nin_step_3_of_4'.tr),
              const SizedBox(height: 12),
              LlTitleBlock(
                title: 'nin_title'.tr,
                subtitle: 'nin_subtitle'.tr,
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'nin_disclaimer'.tr,
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LlSurfaceCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LlFieldLabel('nin_label'.tr),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.ninController,
                      hint: 'nin_hint'.tr,
                      icon: Icons.badge_rounded,
                      keyboardType: TextInputType.name,
                      maxLength: 20,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => widget.controller.generateQuestions(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'nin_demo_map'.tr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        height: 1.35,
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
                        label: 'nin_generate'.tr,
                        onPressed: widget.controller.generateQuestions,
                        isLoading: widget.controller.isLoading.value,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
