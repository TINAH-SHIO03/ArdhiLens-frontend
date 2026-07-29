import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../services/interest_service.dart';

class BuyerInterestController extends GetxController {
  final InterestService _interestService = Get.find<InterestService>();

  final interests = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  final plotController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      final plot = args['plot_reference']?.toString();
      if (plot != null && plot.isNotEmpty) {
        plotController.text = plot;
      }
    }
    loadInterests();
  }

  Future<void> loadInterests() async {
    isLoading.value = true;
    errorMessage.value = null;
    interests.clear();
    try {
      interests.assignAll(await _interestService.buyerInterests());
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'interest_load_failed'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitInterest({int? verificationLogId}) async {
    final plot = plotController.text.trim();
    if (plot.isEmpty) {
      errorMessage.value = 'interest_plot_required'.tr;
      return;
    }

    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      await _interestService.expressInterest(
        plotReference: plot,
        message: messageController.text.trim(),
        verificationLogId: verificationLogId,
      );
      messageController.clear();
      await loadInterests();
      Get.snackbar('interest_title'.tr, 'interest_sent'.tr);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    plotController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
