import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_input.dart';
import '../widgets/primary_button.dart';
import '../controllers/plot_controller.dart';

class PlotScreen extends GetView<PlotController> {
  const PlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Plot'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Step 1: Enter plot reference'),
              const SizedBox(height: 12),
              AppInput(
                controller: controller.plotReferenceController,
                label: 'Plot Reference',
                hint: 'PLOT-001',
              ),
              const SizedBox(height: 16),
              Obx(
                () => PrimaryButton(
                  label: 'Find Plot',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submitPlot,
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
