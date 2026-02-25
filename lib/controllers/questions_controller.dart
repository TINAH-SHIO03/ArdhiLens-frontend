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
      errorMessage.value = 'Challenge expired. Generate new questions.';
      return;
    }

    final verificationToken = _storage.verificationToken;
    final challengeId = _storage.challengeId ?? questionData.challengeId;

    if (verificationToken == null ||
        verificationToken.isEmpty ||
        challengeId.isEmpty) {
      errorMessage.value = 'Verification session missing. Start again.';
      return;
    }

    final answers = <AnswerInput>[];
    for (final question in questionData.questions) {
      final value = answerControllers[question.questionId]?.text.trim() ?? '';
      if (value.isEmpty) {
        errorMessage.value = 'Please answer all questions.';
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
      errorMessage.value = 'Unexpected error while submitting answers.';
    } finally {
      isLoading.value = false;
    }
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
