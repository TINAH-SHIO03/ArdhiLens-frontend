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
      errorMessage.value = 'err_nin_required'.tr;
      return;
    }

    final ninPattern = RegExp(r'^\d{8}-\d{5}-\d{5}$');
    if (!ninPattern.hasMatch(nin)) {
      errorMessage.value = 'err_nin_format'.tr;
      return;
    }

    final verificationToken = _storage.verificationToken;
    if (verificationToken == null || verificationToken.isEmpty) {
      errorMessage.value = 'err_session_missing'.tr;
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
      errorMessage.value = 'err_nin_unexpected'.tr;
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
