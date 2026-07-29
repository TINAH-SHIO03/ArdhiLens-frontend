import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../core/file_save_helper.dart';
import '../core/storage_service.dart';
import '../models/document_item.dart';
import '../services/auth_service.dart';
import '../services/document_service.dart';
import '../services/seller_service.dart';

class DocumentController extends GetxController {
  DocumentController(this._documentService);

  final DocumentService _documentService;
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storage = Get.find<StorageService>();

  final documents = <DocumentItem>[].obs;
  final sellerPlots = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isUploading = false.obs;
  final selectedType = 'other'.obs;
  final selectedPlotId = RxnInt();
  final buyerPlotController = TextEditingController();
  final isSeller = false.obs;

  static const documentTypes = <String>[
    'sale_agreement',
    'transfer_form',
    'certificate_of_occupancy',
    'survey_plan',
    'identification',
    'other',
  ];

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final user = _authService.cachedUser ??
        (_storage.isAuthenticated ? await _authService.me() : null);
    isSeller.value = user?.isSeller == true;

    if (isSeller.value) {
      await _loadSellerPlots();
      await fetchDocuments();
    }
  }

  Future<void> _loadSellerPlots() async {
    try {
      final data = await Get.find<SellerService>().dashboard();
      final raw = data['plots'];
      if (raw is List) {
        sellerPlots.assignAll(
          raw.map((e) => (e as Map).cast<String, dynamic>()).toList(),
        );
        if (sellerPlots.isNotEmpty && selectedPlotId.value == null) {
          selectedPlotId.value =
              int.tryParse('${sellerPlots.first['id']}');
        }
      }
    } catch (_) {
      sellerPlots.clear();
    }
  }

  Future<void> fetchDocuments() async {
    isLoading.value = true;
    documents.clear();
    try {
      if (isSeller.value) {
        final result = await _documentService.getDocuments(
          plotId: selectedPlotId.value,
        );
        documents.assignAll(result['documents'] as List<DocumentItem>);
      } else {
        final plotRef = buyerPlotController.text.trim();
        if (plotRef.isEmpty) {
          documents.clear();
          return;
        }
        final result = await _documentService.getDocuments(
          plotReference: plotRef,
        );
        documents.assignAll(result['documents'] as List<DocumentItem>);
      }
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onSellerPlotChanged(int? plotId) async {
    selectedPlotId.value = plotId;
    await fetchDocuments();
  }

  Future<void> pickAndUpload() async {
    if (!isSeller.value) {
      Get.snackbar('common_error'.tr, 'docs_seller_only'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (selectedPlotId.value == null) {
      Get.snackbar('common_error'.tr, 'docs_select_plot'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      withData: false,
    );

    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null || path.isEmpty) {
      Get.snackbar('common_error'.tr, 'docs_pick_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isUploading.value = true;
    try {
      final uploaded = await _documentService.uploadDocument(
        file: File(path),
        documentType: selectedType.value,
        plotId: selectedPlotId.value!,
      );
      documents.insert(0, uploaded);
      Get.snackbar(
        'docs_uploaded_title'.tr,
        'docs_uploaded_body'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message,
          snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('common_error'.tr, 'docs_upload_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> downloadAndOpen(DocumentItem document) async {
    try {
      final bytes = await _documentService.downloadDocumentBytes(document.id);
      final safeName = document.originalName.replaceAll(
        RegExp(r'[^\w.\-]+'),
        '_',
      );
      final file = await FileSaveHelper.saveBytes(
        bytes: bytes,
        fileName: 'doc_${document.id}_$safeName',
      );
      Get.snackbar(
        'cert_download'.tr,
        'cert_saved_to'.trParams({'path': FileSaveHelper.displayPath(file)}),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message,
          snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('common_error'.tr, 'docs_open_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteDocument(DocumentItem document) async {
    if (!isSeller.value) return;
    try {
      await _documentService.deleteDocument(document.id);
      documents.removeWhere((d) => d.id == document.id);
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  String typeLabel(String type) => 'docs_type_$type'.tr;

  String plotLabel(Map<String, dynamic> plot) {
    final ref = plot['plot_reference']?.toString() ?? '';
    final ward = plot['ward']?.toString() ?? '';
    return ward.isEmpty ? ref : '$ref · $ward';
  }

  @override
  void onClose() {
    buyerPlotController.dispose();
    super.onClose();
  }
}
