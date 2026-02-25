import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/plot_step_data.dart';
import '../services/plot_service.dart';

class PlotController extends GetxController {
  final PlotService _plotService = Get.find<PlotService>();
  final StorageService _storage = Get.find<StorageService>();

  final plotReferenceController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final plotData = Rxn<PlotStepData>();

  Future<void> submitPlot() async {
    final reference = plotReferenceController.text.trim();

    if (reference.isEmpty) {
      errorMessage.value = 'Plot reference is required.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await _plotService.findPlot(reference);
      plotData.value = response;
      Get.toNamed('/gps', arguments: response);
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _storage.clearAuthToken();
        Get.offAllNamed('/login');
        return;
      }
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'Unexpected error while finding plot.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    plotReferenceController.dispose();
    super.onClose();
  }
}
