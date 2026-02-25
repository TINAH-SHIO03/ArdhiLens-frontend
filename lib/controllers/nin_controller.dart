import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../services/nin_service.dart';

class NinController extends GetxController {
  final NinService _ninService = Get.find<NinService>();
  final StorageService _storage = Get.find<StorageService>();

  final ninController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  Future<void> generateQuestions() async {
    final nin = ninController.text.trim();

    if (nin.isEmpty) {
      errorMessage.value = 'NIN is required.';
      return;
    }

    final verificationToken = _storage.verificationToken;
    if (verificationToken == null || verificationToken.isEmpty) {
      errorMessage.value = 'Verification session missing. Start again.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await _ninService.generateQuestions(
        verificationToken: verificationToken,
        nin: nin,
      );

      Get.toNamed('/questions', arguments: response);
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _storage.clearAuthToken();
        Get.offAllNamed('/login');
        return;
      }
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'Unexpected error while generating questions.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    ninController.dispose();
    super.onClose();
  }
}
