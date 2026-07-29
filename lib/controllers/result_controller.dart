import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/assistant_explanation.dart';
import '../models/verification_outcome.dart';
import '../models/verification_result.dart';
import '../routes/app_routes.dart';
import '../services/assistant_service.dart';
import '../services/history_service.dart';
import '../services/interest_service.dart';
import 'certificate_controller.dart';

class ResultController extends GetxController {
  final HistoryService _historyService = Get.find<HistoryService>();
  final StorageService _storage = Get.find<StorageService>();
  final AssistantService _assistantService = Get.find<AssistantService>();
  final InterestService _interestService = Get.find<InterestService>();

  final outcome = Rxn<VerificationOutcome>();
  final isAssistantOpen = false.obs;
  final isAssistantLoading = false.obs;
  final isRecoveringCertificate = false.obs;
  final isSendingInterest = false.obs;
  final assistantError = RxnString();
  final chatMessages = <AssistantChatMessage>[].obs;
  late final TextEditingController questionController;
  late final ScrollController chatScrollController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    outcome.value = args is VerificationOutcome ? args : null;
    questionController = TextEditingController();
    chatScrollController = ScrollController();
    _recoverCertificateIfNeeded();
  }

  Future<void> _recoverCertificateIfNeeded() async {
    final result = outcome.value?.success;
    if (result == null) return;

    final verdict = result.assessment.verdict.toUpperCase();
    final eligible = result.certificateEligible ||
        (result.steps.nidaQuestionsPassed &&
            (verdict == 'SAFE' || verdict == 'CAUTION'));

    if (!eligible || result.certificate != null) {
      return;
    }

    await recoverCertificate();
  }

  Future<void> recoverCertificate() async {
    final result = outcome.value?.success;
    if (result == null || result.verificationLogId <= 0) return;
    if (!Get.isRegistered<CertificateController>()) return;

    isRecoveringCertificate.value = true;
    try {
      final cert = await Get.find<CertificateController>()
          .generateCertificate(result.verificationLogId);
      if (cert == null) return;

      final updated = result.copyWith(
        certificate: VerificationCertificateSummary(
          id: cert.id,
          certificateNumber: cert.certificateNumber,
          issuedAt: cert.issuedAt,
          fingerprint: cert.fingerprint,
          downloadAvailable: cert.pdfPath != null && cert.pdfPath!.isNotEmpty,
        ),
        certificateEligible: true,
        certificateError: null,
      );
      outcome.value = VerificationOutcome.success(updated);
      await _historyService.addHistory(updated.toHistoryJson());
    } finally {
      isRecoveringCertificate.value = false;
    }
  }

  Future<void> expressInterest() async {
    final result = outcome.value?.success;
    if (result == null) return;

    isSendingInterest.value = true;
    try {
      await _interestService.expressInterest(
        plotReference: result.plotReference,
        message: 'interest_default_message'.tr,
        verificationLogId: result.verificationLogId,
      );
      Get.snackbar('interest_title'.tr, 'interest_sent'.tr);
      Get.toNamed(
        Routes.buyerInterests,
        arguments: {'plot_reference': result.plotReference},
      );
    } on ApiException catch (e) {
      Get.snackbar('common_error'.tr, e.message);
    } finally {
      isSendingInterest.value = false;
    }
  }

  String? passportImageUrl() {
    final success = outcome.value?.success;
    final url = success?.identity.passportImageUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    final base = _storage.baseUrl;
    if (base == null || base.isEmpty) {
      return url;
    }

    final normalizedBase = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    final normalizedPath = url.startsWith('/') ? url : '/$url';

    return '$normalizedBase$normalizedPath';
  }

  Future<void> startNew() async {
    await _storage.clearVerificationSession();
    Get.offAllNamed('/plot');
  }

  List<Map<String, dynamic>> get history => _historyService.getHistory();

  bool get canOpenAssistant {
    return _activeVerificationLogId() > 0;
  }

  int get activeVerificationLogId => _activeVerificationLogId();

  void toggleAssistant() {
    if (!canOpenAssistant) {
      return;
    }

    final opening = !isAssistantOpen.value;
    isAssistantOpen.value = opening;

    if (opening && chatMessages.isEmpty) {
      askForUnderstanding(defaultQuestion());
    }
  }

  String defaultQuestion() {
    return 'chat_default_question'.tr;
  }

  Future<void> askForUnderstanding(String question) async {
    if (!canOpenAssistant) {
      return;
    }

    if (isAssistantLoading.value) {
      return;
    }

    final trimmed = question.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final verificationLogId = _activeVerificationLogId();
    if (verificationLogId <= 0) {
      return;
    }

    final conversationHistory = _conversationHistoryPayload();
    assistantError.value = null;
    chatMessages.add(AssistantChatMessage(role: 'user', text: trimmed));
    _scrollChatToBottom();
    isAssistantLoading.value = true;

    try {
      final response = await _assistantService.explainAssessment(
        verificationLogId: verificationLogId,
        question: trimmed,
        conversationHistory: conversationHistory,
      );

      chatMessages.add(
        AssistantChatMessage(
          role: 'assistant',
          text: response.answer,
          related: response.related,
          recommendedAction: response.recommendedAction,
          steps: response.suggestedNextSteps,
        ),
      );
      _scrollChatToBottom();
      questionController.clear();
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _storage.clearAuthToken();
        Get.offAllNamed('/login');
        return;
      }
      assistantError.value = error.message;
      chatMessages.add(
        AssistantChatMessage(
          role: 'assistant',
          text: 'chat_error_response'.tr,
        ),
      );
      _scrollChatToBottom();
    } catch (_) {
      assistantError.value = 'chat_unexpected_error'.tr;
      chatMessages.add(
        AssistantChatMessage(
          role: 'assistant',
          text: 'chat_service_error'.tr,
        ),
      );
      _scrollChatToBottom();
    } finally {
      isAssistantLoading.value = false;
    }
  }

  Future<void> sendAssistantQuestion() async {
    await askForUnderstanding(questionController.text);
  }

  List<String> quickPrompts() {
    return [
      'chat_quick_1'.tr,
      'chat_quick_2'.tr,
      'chat_quick_3'.tr,
      'chat_quick_4'.tr,
    ];
  }

  void useQuickPrompt(String prompt) {
    questionController.text = prompt;
    questionController.selection = TextSelection.fromPosition(
      TextPosition(offset: questionController.text.length),
    );
    sendAssistantQuestion();
  }

  List<Map<String, String>> _conversationHistoryPayload() {
    if (chatMessages.isEmpty) {
      return const [];
    }

    final window = chatMessages.length > 10
        ? chatMessages.sublist(chatMessages.length - 10)
        : chatMessages;

    return window
        .map(
          (message) => <String, String>{
            'role': message.role,
            'text': message.text,
          },
        )
        .toList();
  }

  int _activeVerificationLogId() {
    final successId = outcome.value?.success?.verificationLogId ?? 0;
    if (successId > 0) {
      return successId;
    }
    final failureId = outcome.value?.failure?.verificationLogId ?? 0;
    if (failureId > 0) {
      return failureId;
    }

    final latestHistory = _historyService.getHistory();
    if (latestHistory.isEmpty) {
      return 0;
    }

    final fromHistory = _asInt(latestHistory.first['verification_log_id']) ?? 0;
    return fromHistory > 0 ? fromHistory : 0;
  }

  int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  void _scrollChatToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!chatScrollController.hasClients) {
        return;
      }

      final position = chatScrollController.position.maxScrollExtent;
      chatScrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void onClose() {
    questionController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }
}
