import 'package:get/get.dart';

import '../core/storage_service.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';
import '../services/history_service.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final HistoryService _historyService = Get.find<HistoryService>();
  final StorageService _storage = Get.find<StorageService>();

  final user = Rxn<AuthUser>();
  final history = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    history.assignAll(_historyService.getHistory());

    try {
      user.value = await _authService.me();
    } catch (_) {
      user.value = null;
    }
  }

  void startVerification() {
    Get.toNamed('/plot');
  }

  void openSettings() {
    Get.toNamed('/settings');
  }

  Future<void> logout() async {
    isLoading.value = true;

    try {
      await _authService.logout();
    } catch (_) {
      await _storage.clearVerificationSession();
      await _storage.clearAuthToken();
    } finally {
      isLoading.value = false;
    }

    Get.offAllNamed('/login');
  }
}
