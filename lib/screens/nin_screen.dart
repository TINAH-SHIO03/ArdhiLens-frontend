import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/nin_controller.dart';
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
              const LlStepBadge(label: 'STEP 3 OF 4'),
              const SizedBox(height: 12),
              const LlTitleBlock(
                title: 'Identity Verification',
                subtitle: 'Provide your national ID number',
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
                        'Your NIN is used only for verification and never stored.',
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
                    const LlFieldLabel('National ID Number'),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.ninController,
                      hint: 'e.g., 12345678901234567890',
                      icon: Icons.badge_rounded,
                      keyboardType: TextInputType.number,
                      maxLength: 20,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => widget.controller.generateQuestions(),
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
                        label: 'Generate Questions',
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
