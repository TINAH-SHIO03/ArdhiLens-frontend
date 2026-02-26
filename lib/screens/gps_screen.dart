import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/gps_controller.dart';
import '../widgets/ll_ui.dart';

class GpsScreen extends GetView<GpsController> {
  const GpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GpsScreenContent(controller: controller);
  }
}

class GpsScreenContent extends StatefulWidget {
  const GpsScreenContent({required this.controller, super.key});

  final GpsController controller;

  @override
  State<GpsScreenContent> createState() => _GpsScreenContentState();
}

class _GpsScreenContentState extends State<GpsScreenContent>
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
    final plot = widget.controller.plotData?.plot;
    final plotReference = (plot != null && plot.plotReference.isNotEmpty)
        ? plot.plotReference
        : '-';
    final region = (plot != null && plot.region.isNotEmpty) ? plot.region : '-';
    final district =
        (plot != null && plot.district.isNotEmpty) ? plot.district : '-';

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
              const LlStepBadge(label: 'STEP 2 OF 4'),
              const SizedBox(height: 12),
              const LlTitleBlock(
                title: 'Verify GPS',
                subtitle: 'Submit your exact coordinates',
              ),
              const SizedBox(height: 26),
              if (plot != null)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFFD4AF37),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              plotReference,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$region - $district',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 12,
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
                    const LlFieldLabel('Latitude'),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.latitudeController,
                      hint: 'e.g., -6.8012',
                      icon: Icons.navigation_rounded,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    const LlFieldLabel('Longitude'),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.longitudeController,
                      hint: 'e.g., 39.2021',
                      icon: Icons.navigation_rounded,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => widget.controller.submitGps(),
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
                        label: 'Verify GPS',
                        onPressed: widget.controller.submitGps,
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
