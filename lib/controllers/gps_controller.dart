import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/gps_step_data.dart';
import '../models/plot_step_data.dart';
import '../services/gps_service.dart';

class GpsController extends GetxController {
  final GpsService _gpsService = Get.find<GpsService>();
  final StorageService _storage = Get.find<StorageService>();

  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final gpsData = Rxn<GpsStepData>();

  PlotStepData? plotData;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    plotData = args is PlotStepData ? args : null;
  }

  Future<void> submitGps() async {
    final latitude = double.tryParse(latitudeController.text.trim());
    final longitude = double.tryParse(longitudeController.text.trim());

    if (latitude == null || longitude == null) {
      errorMessage.value = 'Latitude and longitude must be valid numbers.';
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
      final response = await _gpsService.verifyGps(
        verificationToken: verificationToken,
        latitude: latitude,
        longitude: longitude,
      );

      gpsData.value = response;
      Get.toNamed('/nin');
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _storage.clearAuthToken();
        Get.offAllNamed('/login');
        return;
      }
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'Unexpected error while verifying GPS.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }
}
