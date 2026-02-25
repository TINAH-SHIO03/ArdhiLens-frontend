import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../widgets/app_input.dart';
import '../widgets/primary_button.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                'Configure API endpoint and language.\nAndroid emulator should use http://10.0.2.2:8000',
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: controller.baseUrlController,
                label: 'Base URL',
                hint: 'http://10.0.2.2:8000',
              ),
              const SizedBox(height: 16),
              const Text('Language'),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedLanguage.value,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'sw', child: Text('Swahili')),
                  ],
                  onChanged: controller.setLanguage,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Obx(
                () => PrimaryButton(
                  label: 'Save Settings',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.saveSettings,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
