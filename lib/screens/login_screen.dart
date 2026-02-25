import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/app_input.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text('Sign in to continue with land verification.'),
              const SizedBox(height: 16),
              AppInput(
                controller: controller.loginEmailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: controller.loginPasswordController,
                label: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Obx(
                () => PrimaryButton(
                  label: 'Login',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.login,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.toNamed('/register'),
                child: const Text('No account? Register'),
              ),
              const SizedBox(height: 6),
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
