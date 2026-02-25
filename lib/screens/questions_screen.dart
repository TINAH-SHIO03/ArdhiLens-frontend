import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/questions_controller.dart';
import '../widgets/app_input.dart';
import '../widgets/primary_button.dart';

class QuestionsScreen extends GetView<QuestionsController> {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Questions'),
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
              const Text('Step 4: Answer all questions'),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  'Expires in: ${controller.remainingSeconds.value}s',
                  style: TextStyle(
                    color: controller.remainingSeconds.value > 15
                        ? Colors.black87
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...controller.questionData.questions.map((question) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppInput(
                    controller:
                        controller.answerControllers[question.questionId]!,
                    label: question.prompt,
                  ),
                );
              }),
              const SizedBox(height: 8),
              Obx(
                () => PrimaryButton(
                  label: 'Submit Answers',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submitAnswers,
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
