import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/auth_user.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'notification_controller.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storage = Get.find<StorageService>();

  final user = Rxn<AuthUser>();
  final avatarBytes = Rxn<Uint8List>();
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isUploadingAvatar = false.obs;
  final errorMessage = RxnString();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    loadProfile();
  }

  Future<void> loadProfile({bool force = false}) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final loaded = force
          ? await _authService.me(forceRefresh: true)
          : (_authService.cachedUser ?? await _authService.me());
      user.value = loaded;
      nameController.text = loaded.name;
      emailController.text = loaded.email;
      phoneController.text = loaded.phoneNumber ?? '';
      if (loaded.hasAvatar) {
        await _loadAvatar();
      } else {
        avatarBytes.value = null;
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'profile_load_failed'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadAvatar() async {
    try {
      final bytes = await _authService.downloadAvatarBytes();
      avatarBytes.value = Uint8List.fromList(bytes);
    } catch (_) {
      avatarBytes.value = null;
    }
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      errorMessage.value = 'profile_required_fields'.tr;
      return;
    }

    isSaving.value = true;
    errorMessage.value = null;
    try {
      final updated = await _authService.updateProfile(
        name: name,
        email: email,
        phoneNumber: phone.isEmpty ? null : phone,
      );
      user.value = updated;
      Get.snackbar('profile_title'.tr, 'profile_saved'.tr);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> pickAndUploadAvatar() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final path = file.path;
    if (path == null || path.isEmpty) {
      Get.snackbar('common_error'.tr, 'docs_pick_failed'.tr);
      return;
    }

    isUploadingAvatar.value = true;
    try {
      final updated = await _authService.uploadAvatar(path);
      user.value = updated;
      await _loadAvatar();
      Get.snackbar('profile_title'.tr, 'profile_photo_updated'.tr);
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message);
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authService.logout();
    } catch (_) {
      await _storage.clearAuthToken();
      await _storage.clearVerificationSession();
    } finally {
      isLoading.value = false;
    }
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().onLoggedOut();
    }
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
