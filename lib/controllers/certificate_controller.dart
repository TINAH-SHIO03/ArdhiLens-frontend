import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import '../core/api_exception.dart';
import '../core/file_save_helper.dart';
import '../models/verification_certificate.dart';
import '../routes/app_routes.dart';
import '../services/certificate_service.dart';

class CertificateController extends GetxController {
  final CertificateService _certificateService;

  CertificateController(this._certificateService);

  final certificates = <VerificationCertificate>[].obs;
  final currentCertificate = Rxn<VerificationCertificate>();
  final isLoading = false.obs;
  final isGenerating = false.obs;
  final downloadingId = RxnInt();
  final viewingId = RxnInt();

  Future<void> fetchCertificates() async {
    isLoading.value = true;
    certificates.clear();

    try {
      final list = await _certificateService.listCertificates();
      certificates.assignAll(list);
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<VerificationCertificate?> generateCertificate(
    int verificationLogId,
  ) async {
    isGenerating.value = true;

    try {
      final certificate =
          await _certificateService.generateCertificate(verificationLogId);
      currentCertificate.value = certificate;
      certificates.insert(0, certificate);
      return certificate;
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message, snackPosition: SnackPosition.BOTTOM);
      return null;
    } finally {
      isGenerating.value = false;
    }
  }

  Future<void> downloadCertificate(VerificationCertificate certificate) async {
    if (downloadingId.value != null) return;

    downloadingId.value = certificate.id;
    try {
      final bytes =
          await _certificateService.downloadCertificateBytes(certificate.id);
      final file = await FileSaveHelper.saveBytes(
        bytes: bytes,
        fileName: 'ArdhiLens_${certificate.certificateNumber}.pdf',
      );
      Get.snackbar(
        'cert_download'.tr,
        'cert_saved_to'.trParams({'path': FileSaveHelper.displayPath(file)}),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar(
        'common_error'.tr,
        'cert_download_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      downloadingId.value = null;
    }
  }

  Future<void> viewCertificate(VerificationCertificate certificate) async {
    if (viewingId.value != null) return;

    viewingId.value = certificate.id;
    try {
      final bytes =
          await _certificateService.downloadCertificateBytes(certificate.id);
      await Get.toNamed(
        Routes.certificateViewer,
        arguments: {
          'title': certificate.certificateTitle?.isNotEmpty == true
              ? certificate.certificateTitle!
              : certificate.certificateNumber,
          'bytes': Uint8List.fromList(bytes),
        },
      );
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar(
        'common_error'.tr,
        'cert_view_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      viewingId.value = null;
    }
  }

  /// Legacy helper used on result screen — opens saved copy externally.
  Future<void> downloadAndOpen(VerificationCertificate certificate) async {
    await downloadCertificate(certificate);
  }

  Future<void> openSavedExternally(VerificationCertificate certificate) async {
    try {
      final folder = await FileSaveHelper.downloadsFolder();
      final file = File(
        '${folder.path}/ArdhiLens_${certificate.certificateNumber}.pdf',
      );
      if (await file.exists()) {
        await OpenFilex.open(file.path);
        return;
      }
      await downloadCertificate(certificate);
    } catch (_) {
      Get.snackbar('common_error'.tr, 'cert_open_failed'.tr);
    }
  }
}
