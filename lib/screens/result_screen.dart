import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/result_controller.dart';
import '../models/assistant_explanation.dart';
import '../models/owner_link_failure_result.dart';
import '../models/verification_result.dart';
import '../widgets/primary_button.dart';

class ResultScreen extends GetView<ResultController> {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Result'),
        actions: [
          IconButton(
            onPressed: () => Get.offAllNamed('/home'),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final outcome = controller.outcome.value;

          if (outcome == null) {
            return const Center(child: Text('No result available.'));
          }

          if (outcome.isSuccess) {
            return _successView(outcome.success!);
          }

          return _blockedView(outcome.failure!);
        }),
      ),
    );
  }

  Widget _successView(VerificationResult result) {
    final passportUrl = controller.passportImageUrl();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Verification Passed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plot: ${result.plotReference}'),
                Text('Log ID: ${result.verificationLogId}'),
                Text('Name: ${result.identity.fullName ?? '-'}'),
                Text('Gender: ${result.identity.gender ?? '-'}'),
                Text('NIN: ${result.identity.ninMasked ?? '-'}'),
              ],
            ),
          ),
        ),
        if (passportUrl != null && passportUrl.isNotEmpty) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              passportUrl,
              height: 170,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const SizedBox(
                  height: 80,
                  child: Center(child: Text('Passport image unavailable')),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verdict: ${result.assessment.verdictLabel.isNotEmpty ? result.assessment.verdictLabel : result.assessment.verdict}',
                ),
                Text('Risk score: ${result.assessment.riskScore}'),
                const SizedBox(height: 6),
                Text('Recommendation: ${result.assessment.recommendation}'),
                const SizedBox(height: 6),
                const Text('Reasons:'),
                ...result.assessment.reasons.map((reason) => Text('- $reason')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _assistantCard(),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Start New', onPressed: controller.startNew),
      ],
    );
  }

  Widget _blockedView(OwnerLinkFailureResult blocked) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Verification Blocked',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Card(
          color: const Color(0xFFFFF5F5),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(blocked.message),
                const SizedBox(height: 6),
                Text(
                  'Log ID: ${blocked.verificationLogId > 0 ? blocked.verificationLogId : '-'}',
                ),
                Text('Owner Link Passed: ${blocked.ownerLink.passed}'),
                Text('Plot Owner Match: ${blocked.ownerLink.plotOwnerMatch}'),
                Text('History Match: ${blocked.ownerLink.historyOwnerMatch}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verdict: ${blocked.assessment.verdictLabel.isNotEmpty ? blocked.assessment.verdictLabel : blocked.assessment.verdict}',
                ),
                Text('Risk score: ${blocked.assessment.riskScore}'),
                const SizedBox(height: 6),
                Text('Recommendation: ${blocked.assessment.recommendation}'),
                const SizedBox(height: 6),
                const Text('Reasons:'),
                ...blocked.assessment.reasons.map(
                  (reason) => Text('- $reason'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _assistantCard(),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Start New', onPressed: controller.startNew),
      ],
    );
  }

  Widget _assistantCard() {
    return Obx(() {
      final isOpen = controller.isAssistantOpen.value;
      final isLoading = controller.isAssistantLoading.value;
      final error = controller.assistantError.value;
      final messages = controller.chatMessages;
      final canUseAssistant = controller.canOpenAssistant;
      final activeLogId = controller.activeVerificationLogId;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.support_agent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Land Assistant',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Get a clearer explanation, ask follow-up questions, and receive practical next steps.',
              ),
              const SizedBox(height: 4),
              Text(
                activeLogId > 0
                    ? 'Assistant reference log: $activeLogId'
                    : 'Assistant reference log missing for this result.',
                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: canUseAssistant
                      ? controller.toggleAssistant
                      : null,
                  icon: Icon(
                    isOpen ? Icons.expand_less : Icons.chat_bubble_outline,
                  ),
                  label: Text(
                    isOpen ? 'Hide chat' : 'View more / AI assistant',
                  ),
                ),
              ),
              if (!canUseAssistant) ...[
                const SizedBox(height: 8),
                const Text(
                  'Run a new verification to enable AI assistant for this result.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
              if (isOpen) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.quickPrompts().map((prompt) {
                    return ActionChip(
                      avatar: const Icon(Icons.flash_on, size: 16),
                      label: Text(prompt),
                      onPressed: isLoading
                          ? null
                          : () => controller.useQuickPrompt(prompt),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 320,
                    minHeight: 180,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: messages.isEmpty
                      ? const Center(child: Text('No messages yet.'))
                      : ListView.separated(
                          controller: controller.chatScrollController,
                          itemCount: messages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, index) {
                            final message = messages[index];
                            return _chatBubble(message);
                          },
                        ),
                ),
                if (isLoading) ...[
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Assistant is analyzing your question...'),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.questionController,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => controller.sendAssistantQuestion(),
                        decoration: InputDecoration(
                          hintText: 'Ask follow-up...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => controller.sendAssistantQuestion(),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
                if (error != null) ...[
                  const SizedBox(height: 8),
                  Text(error, style: const TextStyle(color: Colors.red)),
                ],
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _chatBubble(AssistantChatMessage message) {
    final isUser = message.isUser;
    final background = isUser ? const Color(0xFFDBEAFE) : Colors.white;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final borderColor = isUser
        ? const Color(0xFF93C5FD)
        : const Color(0xFFE2E8F0);

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width * 0.8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUser ? 'You' : 'Assistant',
                style: TextStyle(
                  fontSize: 12,
                  color: isUser
                      ? const Color(0xFF1D4ED8)
                      : const Color(0xFF475569),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(message.text, style: const TextStyle(fontSize: 14)),
              if (!isUser && message.steps.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Suggested next steps:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                ...message.steps.map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('- $step'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
