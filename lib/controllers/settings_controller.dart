import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/storage_service.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'notification_controller.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final AuthService _authService = Get.find<AuthService>();

  final selectedLanguage = 'en'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = _storage.languageCode;
  }

  Future<void> setLanguage(String? value) async {
    if (value == null || value.isEmpty) return;
    final lang = value == 'sw' ? 'sw' : 'en';
    selectedLanguage.value = lang;
    await _storage.setLanguageCode(lang);
    await Get.updateLocale(Locale(lang));
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authService.logout();
    } catch (_) {
      await _storage.clearAuthToken();
      await _storage.clearVerificationSession();
    } finally {
      isLoading.value = false;
    }
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().onLoggedOut();
    }
    Get.offAllNamed(Routes.login);
  }
}
