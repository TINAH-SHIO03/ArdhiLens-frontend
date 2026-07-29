import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  final isLocating = false.obs;
  final errorMessage = RxnString();
  final gpsData = Rxn<GpsStepData>();
  final usingDeviceLocation = false.obs;

  final mapLatitude = RxnDouble();
  final mapLongitude = RxnDouble();
  final lastAccuracy = RxnDouble();
  final lastAltitude = RxnDouble();
  final lastSpeed = RxnDouble();

  PlotStepData? plotData;

  bool get hasPlotGps =>
      plotData?.plot.gpsLatitude != null && plotData?.plot.gpsLongitude != null;

  double? get plotLatitude => plotData?.plot.gpsLatitude;
  double? get plotLongitude => plotData?.plot.gpsLongitude;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    plotData = args is PlotStepData ? args : null;

    latitudeController.addListener(_syncFromTextFields);
    longitudeController.addListener(_syncFromTextFields);

    // Default to the registered plot location so remote verification works
    // from anywhere (e.g. Dar checking an Arusha plot).
    _applyPlotLocation();
  }

  void _applyPlotLocation() {
    if (!hasPlotGps) return;
    latitudeController.text = plotLatitude!.toStringAsFixed(6);
    longitudeController.text = plotLongitude!.toStringAsFixed(6);
    lastAccuracy.value = null;
    lastAltitude.value = null;
    lastSpeed.value = null;
    usingDeviceLocation.value = false;
    errorMessage.value = null;
  }

  void usePlotLocation() {
    if (!hasPlotGps) {
      errorMessage.value = 'gps_not_recorded'.tr;
      return;
    }
    _applyPlotLocation();
  }

  void _syncFromTextFields() {
    final lat = double.tryParse(latitudeController.text.trim());
    final lng = double.tryParse(longitudeController.text.trim());
    mapLatitude.value = lat;
    mapLongitude.value = lng;
  }

  Future<void> useCurrentLocation({bool silent = false}) async {
    if (isLocating.value) return;

    isLocating.value = true;
    if (!silent) {
      errorMessage.value = null;
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!silent) {
          errorMessage.value = 'gps_location_disabled'.tr;
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!silent) {
          errorMessage.value = 'gps_location_denied'.tr;
        }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!silent) {
          errorMessage.value = 'gps_location_denied_forever'.tr;
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);
      lastAccuracy.value = position.accuracy;
      lastAltitude.value = position.altitude;
      lastSpeed.value = position.speed;
      usingDeviceLocation.value = true;
      errorMessage.value = null;
    } catch (_) {
      if (!silent) {
        errorMessage.value = 'gps_location_failed'.tr;
      }
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> submitGps() async {
    final latitude = double.tryParse(latitudeController.text.trim());
    final longitude = double.tryParse(longitudeController.text.trim());

    if (latitude == null || longitude == null) {
      errorMessage.value = 'gps_coords_invalid'.tr;
      return;
    }

    final verificationToken = _storage.verificationToken;
    if (verificationToken == null || verificationToken.isEmpty) {
      errorMessage.value = 'gps_session_missing'.tr;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await _gpsService.verifyGps(
        verificationToken: verificationToken,
        latitude: latitude,
        longitude: longitude,
        accuracyMeters: lastAccuracy.value,
        altitude: lastAltitude.value,
        speedMps: lastSpeed.value,
        mode: 'remote',
      );

      gpsData.value = response;

      final mode = response.gpsCheck.verificationMode;
      final snackTitle = mode == 'verified_on_site'
          ? 'gps_mode_on_site_title'.tr
          : 'gps_mode_remote_title'.tr;
      final snackBody = mode == 'verified_on_site'
          ? 'gps_mode_on_site_body'.tr
          : 'gps_mode_remote_body'.tr;

      Get.snackbar(
        snackTitle,
        snackBody,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0A3D2E),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      );

      Get.toNamed('/nin');
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _storage.clearAuthToken();
        Get.offAllNamed('/login');
        return;
      }

      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'gps_unexpected_error'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    latitudeController.removeListener(_syncFromTextFields);
    longitudeController.removeListener(_syncFromTextFields);
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }
}
