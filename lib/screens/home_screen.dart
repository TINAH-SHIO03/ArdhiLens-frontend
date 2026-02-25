import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../widgets/primary_button.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LandLens Home'),
        actions: [
          IconButton(
            onPressed: controller.openSettings,
            icon: const Icon(Icons.settings),
          ),
          Obx(
            () => IconButton(
              onPressed: controller.isLoading.value ? null : controller.logout,
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadHomeData,
          child: Obx(
            () => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Name: ${controller.user.value?.name ?? '-'}'),
                        Text('Email: ${controller.user.value?.email ?? '-'}'),
                        Text('Role: ${controller.user.value?.role ?? '-'}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: 'Start Land Verification',
                  onPressed: controller.startVerification,
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  label: 'Open Settings',
                  onPressed: controller.openSettings,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Recent Verification History',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (controller.history.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('No verification history yet.'),
                    ),
                  ),
                ...controller.history.map((item) {
                  final type = item['type']?.toString() ?? '-';
                  final verdict = item['verdict']?.toString() ?? '-';
                  final risk = item['risk_score']?.toString() ?? '-';
                  final plotRef = item['plot_reference']?.toString() ?? '-';
                  final time = item['timestamp']?.toString() ?? '-';

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: $type | Verdict: $verdict | Risk: $risk'),
                          Text('Plot: $plotRef'),
                          Text('Time: $time'),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
