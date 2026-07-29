import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../controllers/notification_controller.dart';
import '../core/storage_service.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final selectedRole = 'buyer'.obs;

  Future<void> login() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'err_email_password_required'.tr;
      return;
    }

    errorMessage.value = null;
    isLoading.value = true;

    try {
      final session = await _authService.login(email: email, password: password);
      _goHomeForRole(session.user.role);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = 'err_login_failed'.trParams({'error': '$error'});
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final name = registerNameController.text.trim();
    final email = registerEmailController.text.trim();
    final phone = registerPhoneController.text.trim();
    final password = registerPasswordController.text.trim();
    final confirmPassword = registerConfirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      errorMessage.value = 'err_register_required'.tr;
      return;
    }

    if (password != confirmPassword) {
      errorMessage.value = 'err_passwords_mismatch'.tr;
      return;
    }

    errorMessage.value = null;
    isLoading.value = true;

    try {
      await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        phoneNumber: phone.isEmpty ? null : phone,
        role: selectedRole.value,
      );

      _goHomeForRole(selectedRole.value);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = 'err_register_failed'.trParams({'error': '$error'});
    } finally {
      isLoading.value = false;
    }
  }

  final lastResetDebugCode = RxnString();

  Future<void> requestPasswordReset(String email) async {
    if (email.isEmpty) {
      errorMessage.value = 'common_email'.tr;
      return;
    }
    errorMessage.value = null;
    lastResetDebugCode.value = null;
    isLoading.value = true;
    try {
      final data = await _authService.requestPasswordReset(email);
      final code = data?['debug_code']?.toString();
      if (code != null && code.isNotEmpty) {
        lastResetDebugCode.value = code;
      }
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
    required String confirm,
  }) async {
    if (password != confirm) {
      errorMessage.value = 'err_passwords_mismatch'.tr;
      return;
    }
    errorMessage.value = null;
    isLoading.value = true;
    try {
      await _authService.resetPassword(
        email: email,
        code: code,
        password: password,
        passwordConfirmation: confirm,
      );
      Get.offAllNamed('/login');
      Get.snackbar('auth_reset_password'.tr, 'auth_reset_success'.tr);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  }

  void _goHomeForRole(String role) {
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().onAuthenticated();
    }
    Get.find<StorageService>().setUserRole(role);
    final route = role.toLowerCase() == 'seller'
        ? Routes.sellerHome
        : Routes.home;
    Get.offAllNamed(route);
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerNameController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    super.onClose();
  }
}
