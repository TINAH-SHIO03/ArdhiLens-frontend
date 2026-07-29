import 'package:get/get.dart';

import '../core/storage_service.dart';
import '../models/auth_user.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/history_service.dart';
import 'notification_controller.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final HistoryService _historyService = Get.find<HistoryService>();
  final StorageService _storage = Get.find<StorageService>();

  final user = Rxn<AuthUser>();
  final history = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  bool get isSeller => user.value?.isSeller == true;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData({bool forceRefreshUser = false}) async {
    history.clear();
    history.assignAll(_historyService.getHistory());

    try {
      // Prefer cached session user — only hit /auth/me when needed.
      user.value = forceRefreshUser
          ? await _authService.me(forceRefresh: true)
          : (_authService.cachedUser ?? await _authService.me());
      history.assignAll(_historyService.getHistory());
      if (user.value?.isSeller == true) {
        Get.offAllNamed(Routes.sellerHome);
        return;
      }
    } catch (_) {
      user.value = null;
      history.clear();
    }
  }

  void startVerification() {
    Get.toNamed('/plot');
  }

  void openDocuments() {
    Get.toNamed(Routes.documents);
  }

  void openCertificates() {
    Get.toNamed(Routes.certificate);
  }

  void openBuyerInterests() {
    Get.toNamed(Routes.buyerInterests);
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

    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().onLoggedOut();
    }

    Get.offAllNamed('/login');
  }
}
