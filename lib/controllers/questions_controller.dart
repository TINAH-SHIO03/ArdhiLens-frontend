import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/answer_input.dart';
import '../models/nin_question_step_data.dart';
import '../models/owner_link_failure_result.dart';
import '../models/verification_outcome.dart';
import '../services/answers_service.dart';
import '../services/history_service.dart';
import 'notification_controller.dart';

class QuestionsController extends GetxController {
  final AnswersService _answersService = Get.find<AnswersService>();
  final StorageService _storage = Get.find<StorageService>();
  final HistoryService _historyService = Get.find<HistoryService>();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final remainingSeconds = 0.obs;

  late final NinQuestionStepData questionData;
  late final Map<String, TextEditingController> answerControllers;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    questionData = Get.arguments as NinQuestionStepData;
    answerControllers = {
      for (final question in questionData.questions)
        question.questionId: TextEditingController(),
    };
    _startTimer();
  }

  void _startTimer() {
    void update() {
      final diff = questionData.expiresAt.difference(DateTime.now()).inSeconds;
      remainingSeconds.value = diff < 0 ? 0 : diff;
    }

    update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => update());
  }

  Future<void> submitAnswers() async {
    if (remainingSeconds.value <= 0) {
      errorMessage.value = 'err_challenge_expired'.tr;
      return;
    }

    final verificationToken = _storage.verificationToken;
    final challengeId = _storage.challengeId ?? questionData.challengeId;

    if (verificationToken == null ||
        verificationToken.isEmpty ||
        challengeId.isEmpty) {
      errorMessage.value = 'err_session_missing'.tr;
      return;
    }

    final answers = <AnswerInput>[];
    for (final question in questionData.questions) {
      final value = answerControllers[question.questionId]?.text.trim() ?? '';
      if (value.isEmpty) {
        errorMessage.value = 'err_answer_all'.tr;
        return;
      }
      answers.add(AnswerInput(questionId: question.questionId, answer: value));
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _answersService.verifyAnswers(
        verificationToken: verificationToken,
        challengeId: challengeId,
        answers: answers,
      );

      await _historyService.addHistory(result.toHistoryJson());
      // Only bump unread badge — do not reload notification/certificate lists here.
      if (Get.isRegistered<NotificationController>()) {
        await Get.find<NotificationController>().refreshUnreadCount();
      }
      Get.offNamed('/result', arguments: VerificationOutcome.success(result));
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _storage.clearAuthToken();
        Get.offAllNamed('/login');
        return;
      }

      if (error.statusCode == 403 && error.errors?['assessment'] != null) {
        final blocked = OwnerLinkFailureResult.fromError(
          error.message,
          error.errors,
        );
        await _historyService.addHistory(blocked.toHistoryJson());
        Get.offNamed(
          '/result',
          arguments: VerificationOutcome.failure(blocked),
        );
        return;
      }

      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'err_answers_unexpected'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasDemoAnswers =>
      questionData.questions.any((q) => (q.demoAnswer ?? '').isNotEmpty);

  void fillDemoAnswers() {
    for (final question in questionData.questions) {
      final answer = question.demoAnswer;
      if (answer == null || answer.isEmpty) continue;
      answerControllers[question.questionId]?.text = answer;
    }
    errorMessage.value = null;
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (final controller in answerControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
}
