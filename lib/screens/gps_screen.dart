import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/gps_controller.dart';
import '../design/app_colors.dart';
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
    final region = (plot != null && plot.region.isNotEmpty)
        ? plot.region
        : '-';
    final district =
        (plot != null && plot.district.isNotEmpty) ? plot.district : '-';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.brandDeep, AppColors.brand],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const LlBackButton(),
                  const SizedBox(height: 16),
                  LlStepBadge(label: 'gps_step_2_of_4'.tr),
                  const SizedBox(height: 10),
                  LlTitleBlock(
                    title: 'gps_title'.tr,
                    subtitle: 'gps_subtitle'.tr,
                  ),
                  if (plot != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFFD4AF37),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '$plotReference  ·  $region - $district',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Body
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Map
                        _buildMapCard(),
                        const SizedBox(height: 16),

                        // Optional on-site GPS + restore plot location
                        Obx(
                          () => LlSurfaceCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.my_location_rounded,
                                      size: 18,
                                      color: AppColors.brand,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'gps_use_device_title'.tr,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'gps_use_device_desc'.tr,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                LlPrimaryButton(
                                  label: 'gps_use_device_btn'.tr,
                                  onPressed: () =>
                                      widget.controller.useCurrentLocation(),
                                  isLoading: widget.controller.isLocating.value,
                                ),
                                if (widget.controller.hasPlotGps) ...[
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: OutlinedButton.icon(
                                      onPressed:
                                          widget.controller.usePlotLocation,
                                      icon: const Icon(
                                        Icons.landscape_rounded,
                                        size: 18,
                                      ),
                                      label: Text('gps_use_plot_btn'.tr),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.brandDeep,
                                        side: const BorderSide(
                                          color: AppColors.brand,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Coordinate inputs
                        LlSurfaceCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.edit_location_alt_rounded,
                                    size: 18,
                                    color: AppColors.brand,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'gps_coordinates'.tr,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              LlFieldLabel('gps_latitude'.tr),
                              const SizedBox(height: 6),
                              LlInputField(
                                controller:
                                    widget.controller.latitudeController,
                                hint: 'gps_lat_hint'.tr,
                                icon: Icons.navigation_rounded,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: true,
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 14),
                              LlFieldLabel('gps_longitude'.tr),
                              const SizedBox(height: 6),
                              LlInputField(
                                controller:
                                    widget.controller.longitudeController,
                                hint: 'gps_lng_hint'.tr,
                                icon: Icons.navigation_rounded,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: true,
                                ),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) =>
                                    widget.controller.submitGps(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Obx(() {
                          final error =
                              widget.controller.errorMessage.value;
                          if (error == null) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: LlErrorBanner(message: error),
                          );
                        }),

                        Obx(
                          () => LlPrimaryButton(
                            label: 'gps_verify'.tr,
                            onPressed: widget.controller.submitGps,
                            isLoading: widget.controller.isLoading.value,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return LlSurfaceCard(
      padding: EdgeInsets.zero,
      shadowOpacity: 0.08,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 240,
          child: widget.controller.hasPlotGps
              ? _buildFlutterMap()
              : _buildEmptyMap(),
        ),
      ),
    );
  }

  Widget _buildFlutterMap() {
    final plotLatLng = LatLng(
      widget.controller.plotLatitude!,
      widget.controller.plotLongitude!,
    );

    return Obx(() {
      final lat = widget.controller.mapLatitude.value;
      final lng = widget.controller.mapLongitude.value;
      final hasSubmitted = lat != null && lng != null;
      final submittedLatLng = hasSubmitted ? LatLng(lat, lng) : null;

      final markers = <Marker>[
        Marker(
          point: plotLatLng,
          width: 36,
          height: 36,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.brandDeep,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.landscape_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ];

      if (submittedLatLng != null) {
        markers.add(
          Marker(
            point: submittedLatLng,
            width: 36,
            height: 36,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_pin_circle_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        );
      }

      final center = submittedLatLng ?? plotLatLng;
      final zoom = hasSubmitted ? 16.0 : 15.0;

      return FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: zoom,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.ardhilens.app',
          ),
          if (submittedLatLng != null)
            CircleLayer(
              circles: [
                CircleMarker(
                  point: plotLatLng,
                  radius: 250,
                  useRadiusInMeter: true,
                  color: AppColors.brand.withValues(alpha: 0.12),
                  borderColor: AppColors.brand.withValues(alpha: 0.5),
                  borderStrokeWidth: 1.5,
                ),
              ],
            ),
          MarkerLayer(markers: markers),
        ],
      );
    });
  }

  Widget _buildEmptyMap() {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_rounded,
              size: 40,
              color: AppColors.brandDeep,
            ),
            SizedBox(height: 8),
            Text(
              'gps_not_recorded'.tr,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

