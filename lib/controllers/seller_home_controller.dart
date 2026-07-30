import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/auth_user.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/interest_service.dart';
import '../services/seller_service.dart';
import 'notification_controller.dart';

class SellerHomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final SellerService _sellerService = Get.find<SellerService>();
  final InterestService _interestService = Get.find<InterestService>();
  final StorageService _storage = Get.find<StorageService>();

  final user = Rxn<AuthUser>();
  final plots = <Map<String, dynamic>>[].obs;
  final buyerInterests = <Map<String, dynamic>>[].obs;
  final recentVerifications = <Map<String, dynamic>>[].obs;
  final kycStatus = 'none'.obs;
  final unread = 0.obs;
  final plotLinkStatus = 'no_nin'.obs;
  final plotLinkMessage = ''.obs;
  final linkedPlotCount = 0.obs;
  final pendingInterestCount = 0.obs;
  final isLoading = false.obs;
  final isLoadingInterests = false.obs;
  final isLoadingVerifications = false.obs;
  final respondingId = RxnInt();
  final errorMessage = RxnString();

  final ninController = TextEditingController();
  final replyController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    refreshDashboard();
  }

  Future<void> refreshDashboard() async {
    isLoading.value = true;
    errorMessage.value = null;
    plots.clear();
    buyerInterests.clear();
    recentVerifications.clear();
    kycStatus.value = 'none';
    unread.value = 0;
    plotLinkStatus.value = 'no_nin';
    plotLinkMessage.value = '';
    linkedPlotCount.value = 0;
    pendingInterestCount.value = 0;

    try {
      // 1) Use cached user when available — avoid /auth/me on every open.
      user.value = _authService.cachedUser ?? await _authService.me();
      if (user.value?.isSeller != true) {
        Get.offAllNamed(Routes.home);
        return;
      }

      // 2) Lightweight summary only (plots + KYC + counts).
      final data = await _sellerService.dashboard();
      _applySummary(data);

      if (user.value?.nin != null) {
        ninController.text = user.value!.nin!;
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'seller_load_failed'.tr;
    } finally {
      isLoading.value = false;
    }

    // 3) Load heavier sections one at a time after first paint.
    await _loadInterests();
    await _loadRecentVerifications();
  }

  void _applySummary(Map<String, dynamic> data) {
    kycStatus.value = data['kyc_status']?.toString() ?? 'none';
    unread.value = int.tryParse('${data['alerts_unread'] ?? 0}') ?? 0;
    pendingInterestCount.value =
        int.tryParse('${data['pending_interest_count'] ?? 0}') ?? 0;
    plotLinkStatus.value = data['plot_link_status']?.toString() ?? 'no_nin';
    plotLinkMessage.value = data['plot_link_message']?.toString() ?? '';
    linkedPlotCount.value =
        int.tryParse('${data['linked_plot_count'] ?? 0}') ?? 0;

    final current = user.value;
    if (current != null) {
      final updated = current.copyWith(
        kycStatus: kycStatus.value,
        nin: data['nin']?.toString() ?? current.nin,
      );
      user.value = updated;
      _authService.updateCachedUser(updated);
    }

    final rawPlots = data['plots'];
    if (rawPlots is List) {
      plots.assignAll(
        rawPlots.map((e) => (e as Map).cast<String, dynamic>()).toList(),
      );
    } else {
      plots.clear();
    }
  }

  Future<void> _loadInterests() async {
    isLoadingInterests.value = true;
    try {
      final list = await _interestService.sellerInterests();
      buyerInterests.assignAll(list);
      pendingInterestCount.value =
          list.where((e) => e['status']?.toString() == 'pending').length;
    } on ApiException catch (e) {
      // Keep summary visible; show soft error only if nothing else failed.
      errorMessage.value ??= e.message;
    } finally {
      isLoadingInterests.value = false;
    }
  }

  Future<void> _loadRecentVerifications() async {
    isLoadingVerifications.value = true;
    try {
      recentVerifications
          .assignAll(await _sellerService.recentVerifications());
    } on ApiException catch (_) {
      // Optional section — ignore soft failures.
    } finally {
      isLoadingVerifications.value = false;
    }
  }

  Future<void> submitKyc() async {
    final nin = ninController.text.trim();
    if (nin.length != 20) {
      errorMessage.value = 'seller_nin_invalid'.tr;
      return;
    }
    isLoading.value = true;
    try {
      await _sellerService.submitKyc(nin: nin);
      await _authService.me(forceRefresh: true);
      await refreshDashboard();
      Get.snackbar('seller_kyc_title'.tr, 'seller_kyc_submitted'.tr);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> respondToInterest(int id, String status) async {
    respondingId.value = id;
    try {
      await _interestService.respond(
        interestId: id,
        status: status,
        reply: replyController.text.trim(),
      );
      replyController.clear();
      await _loadInterests();
      Get.snackbar('seller_buyers_title'.tr, 'seller_response_saved'.tr);
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message);
    } finally {
      respondingId.value = null;
    }
  }

  void startOwnershipProof() {
    if (kycStatus.value == 'none' || (user.value?.nin?.isEmpty ?? true)) {
      Get.snackbar(
        'seller_kyc_title'.tr,
        'seller_kyc_required_for_proof'.tr,
      );
      return;
    }
    if (linkedPlotCount.value <= 0) {
      Get.snackbar(
        'seller_plot_link_title'.tr,
        plotLinkMessage.value.isNotEmpty
            ? plotLinkMessage.value
            : 'seller_no_plots'.tr,
      );
      return;
    }
    Get.toNamed(Routes.plot);
  }

  void openDocuments() => Get.toNamed(Routes.documents);

  void openCertificates() => Get.toNamed(Routes.certificate);

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (_) {
      await _storage.clearAuthToken();
    }
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().onLoggedOut();
    }
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    ninController.dispose();
    replyController.dispose();
    super.onClose();
  }
}
