import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  late final TextEditingController baseUrlController;
  final selectedLanguage = 'en'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    baseUrlController = TextEditingController(text: _storage.baseUrl ?? '');
    selectedLanguage.value = _storage.languageCode;
  }

  Future<void> saveSettings() async {
    final baseUrl = baseUrlController.text.trim();

    if (baseUrl.isEmpty) {
      Get.snackbar('Missing field', 'Base URL is required.');
      return;
    }

    isLoading.value = true;

    try {
      final oldBaseUrl = _storage.baseUrl;
      final changedBaseUrl = oldBaseUrl != null && oldBaseUrl.trim() != baseUrl;

      await _storage.setBaseUrl(baseUrl);
      await _storage.setLanguageCode(selectedLanguage.value);

      if (changedBaseUrl) {
        await _storage.clearAuthToken();
        await _storage.clearVerificationSession();
        Get.offAllNamed('/login');
        return;
      }

      if (_storage.isAuthenticated) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    } on ApiException catch (error) {
      Get.snackbar('Save failed', error.message);
    } catch (_) {
      Get.snackbar('Save failed', 'Unexpected error while saving settings.');
    } finally {
      isLoading.value = false;
    }
  }

  void setLanguage(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }

    selectedLanguage.value = value == 'sw' ? 'sw' : 'en';
  }

  @override
  void onClose() {
    baseUrlController.dispose();
    super.onClose();
  }
}
