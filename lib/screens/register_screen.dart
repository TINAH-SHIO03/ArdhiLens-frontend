import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/app_input.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text('Create account for verification flow.'),
              const SizedBox(height: 16),
              AppInput(
                controller: controller.registerNameController,
                label: 'Full name',
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: controller.registerEmailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: controller.registerPhoneController,
                label: 'Phone (optional)',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: controller.registerPasswordController,
                label: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: controller.registerConfirmPasswordController,
                label: 'Confirm password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Obx(
                () => PrimaryButton(
                  label: 'Register',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.register,
                ),
              ),
              TextButton(
                onPressed: () => Get.offAllNamed('/login'),
                child: const Text('Already have an account? Login'),
              ),
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
