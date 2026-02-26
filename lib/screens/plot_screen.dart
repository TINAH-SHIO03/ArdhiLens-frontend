import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/plot_controller.dart';
import '../widgets/ll_ui.dart';

class PlotScreen extends GetView<PlotController> {
  const PlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlotScreenContent(controller: controller);
  }
}

class PlotScreenContent extends StatefulWidget {
  const PlotScreenContent({required this.controller, super.key});

  final PlotController controller;

  @override
  State<PlotScreenContent> createState() => _PlotScreenContentState();
}

class _PlotScreenContentState extends State<PlotScreenContent>
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
              const LlStepBadge(label: 'STEP 1 OF 4'),
              const SizedBox(height: 12),
              const LlTitleBlock(
                title: 'Find Your Plot',
                subtitle: 'Enter your plot reference number',
              ),
              const SizedBox(height: 40),
              LlSurfaceCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LlFieldLabel('Plot Reference'),
                    const SizedBox(height: 12),
                    LlInputField(
                      controller: widget.controller.plotReferenceController,
                      hint: 'e.g., PLOT-001',
                      icon: Icons.location_on_outlined,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => widget.controller.submitPlot(),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      final error = widget.controller.errorMessage.value;
                      if (error == null) {
                        return const SizedBox.shrink();
                      }
                      return LlErrorBanner(message: error);
                    }),
                    Obx(
                      () => LlPrimaryButton(
                        label: 'Find Plot',
                        onPressed: widget.controller.submitPlot,
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
