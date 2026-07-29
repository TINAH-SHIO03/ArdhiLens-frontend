import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/questions_controller.dart';
import '../design/app_colors.dart';
import '../widgets/ll_ui.dart';

class QuestionsScreen extends GetView<QuestionsController> {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return QuestionsScreenContent(controller: controller);
  }
}

class QuestionsScreenContent extends StatefulWidget {
  const QuestionsScreenContent({required this.controller, super.key});

  final QuestionsController controller;

  @override
  State<QuestionsScreenContent> createState() => _QuestionsScreenContentState();
}

class _QuestionsScreenContentState extends State<QuestionsScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LlHeaderShell(
      headerHeight: 250,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const LlBackButton(),
              const SizedBox(height: 20),
              LlStepBadge(label: 'q_step_4_of_4'.tr),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LlTitleBlock(
                      title: 'q_title'.tr,
                      subtitle: 'q_subtitle'.tr,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(() {
                    final remaining = widget.controller.remainingSeconds.value;
                    final isWarning = remaining <= 15;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isWarning
                            ? Colors.red.shade400.withValues(alpha: 0.9)
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isWarning
                              ? Colors.red.shade300
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        (() {
                          final m = remaining ~/ 60;
                          final s = remaining % 60;
                          return '$m:${s.toString().padLeft(2, '0')}';
                        })(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 28),
              if (widget.controller.hasDemoAnswers) ...[
                LlSurfaceCard(
                  padding: const EdgeInsets.all(16),
                  radius: 16,
                  shadowOpacity: 0.04,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.tips_and_updates_outlined,
                            color: AppColors.brandDeep,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'q_demo_title'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'q_demo_desc'.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...widget.controller.questionData.questions
                          .where((q) => (q.demoAnswer ?? '').isNotEmpty)
                          .map(
                            (q) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                '• ${q.demoAnswer}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brandDeep,
                                ),
                              ),
                            ),
                          ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: widget.controller.fillDemoAnswers,
                          icon: const Icon(Icons.checklist_rounded, size: 18),
                          label: Text('q_demo_fill'.tr),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.brandDeep,
                            side: const BorderSide(color: AppColors.brand),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ..._buildQuestionCards(),
              const SizedBox(height: 24),
              Obx(() {
                final error = widget.controller.errorMessage.value;
                if (error == null) {
                  return const SizedBox.shrink();
                }
                return LlErrorBanner(message: error);
              }),
              Obx(
                () => LlPrimaryButton(
                  label: 'q_submit'.tr,
                  onPressed: widget.controller.submitAnswers,
                  isLoading: widget.controller.isLoading.value,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildQuestionCards() {
    return widget.controller.questionData.questions.asMap().entries.map((entry) {
      final index = entry.key;
      final question = entry.value;
      final textController =
          widget.controller.answerControllers[question.questionId];

      if (textController == null) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: LlSurfaceCard(
          padding: const EdgeInsets.all(20),
          radius: 20,
          shadowOpacity: 0.06,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppColors.brandDeep,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question.prompt.isNotEmpty ? question.prompt : 'q_fallback'.tr,
                      style: const TextStyle(
                        color: Color(0xFF424242),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LlInputField(
                controller: textController,
                hint: 'q_hint'.tr,
                icon: Icons.edit_rounded,
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
