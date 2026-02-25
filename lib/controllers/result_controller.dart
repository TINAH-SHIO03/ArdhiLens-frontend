import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/assistant_explanation.dart';
import '../models/verification_outcome.dart';
import '../services/assistant_service.dart';
import '../services/history_service.dart';

class ResultController extends GetxController {
  final HistoryService _historyService = Get.find<HistoryService>();
  final StorageService _storage = Get.find<StorageService>();
  final AssistantService _assistantService = Get.find<AssistantService>();

  final outcome = Rxn<VerificationOutcome>();
  final isAssistantOpen = false.obs;
  final isAssistantLoading = false.obs;
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
    return _storage.languageCode == 'sw'
        ? 'Naomba ufafanuzi wa kina wa matokeo haya kwa mnunuzi.'
        : 'Please explain this result in detail for a buyer.';
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
          text: _storage.languageCode == 'sw'
              ? 'Samahani, nimekwama kujibu swali hilo kwa sasa. Tafadhali jaribu tena au uliza kwa namna nyingine.'
              : 'I could not answer that follow-up right now. Please try again or rephrase the question.',
        ),
      );
      _scrollChatToBottom();
    } catch (_) {
      assistantError.value = _storage.languageCode == 'sw'
          ? 'Hitilafu isiyotarajiwa wakati wa kupata ufafanuzi.'
          : 'Unexpected error while getting explanation.';
      chatMessages.add(
        AssistantChatMessage(
          role: 'assistant',
          text: _storage.languageCode == 'sw'
              ? 'Huduma ya maelezo imepata hitilafu ya muda. Tafadhali jaribu tena baada ya muda mfupi.'
              : 'The explanation service had a temporary issue. Please try again shortly.',
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
    if (_storage.languageCode == 'sw') {
      return const [
        'Hii sababu ina maana gani kwa mnunuzi?',
        'Ni nyaraka gani nihakiki kabla ya kulipa?',
        'Ni madhara gani nikipuuzia tahadhari hizi?',
        'Niende wapi kupata msaada rasmi wa ardhi?',
      ];
    }

    return const [
      'What does this risk reason mean for a buyer?',
      'Which documents should I verify before payment?',
      'What can happen if I ignore these warnings?',
      'Where should I get official land help?',
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
