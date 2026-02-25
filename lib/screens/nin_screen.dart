import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/nin_controller.dart';
import '../widgets/app_input.dart';
import '../widgets/primary_button.dart';

class NinScreen extends GetView<NinController> {
  const NinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NIN Challenge'),
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
              const Text('Step 3: Enter NIN to generate dynamic questions'),
              const SizedBox(height: 12),
              AppInput(
                controller: controller.ninController,
                label: 'NIN',
                hint: '20-digit NIN',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Obx(
                () => PrimaryButton(
                  label: 'Generate Questions',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.generateQuestions,
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
