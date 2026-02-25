import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/gps_controller.dart';
import '../widgets/app_input.dart';
import '../widgets/primary_button.dart';

class GpsScreen extends GetView<GpsController> {
  const GpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plot = controller.plotData?.plot;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Verification'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/home'),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text('Step 2: Submit your coordinates'),
              const SizedBox(height: 8),
              if (plot != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plot: ${plot.plotReference}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Region: ${plot.region}'),
                        Text('District/Ward: ${plot.district} / ${plot.ward}'),
                        Text(
                          'Official GPS: ${plot.gpsLatitude ?? '-'}, ${plot.gpsLongitude ?? '-'}',
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              AppInput(
                controller: controller.latitudeController,
                label: 'Latitude',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: controller.longitudeController,
                label: 'Longitude',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => PrimaryButton(
                  label: 'Verify GPS',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submitGps,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                final error = controller.errorMessage.value;
                if (error == null) {
                  return const SizedBox.shrink();
                }
                return Text(error, style: const TextStyle(color: Colors.red));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
