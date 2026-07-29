import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/result_controller.dart';
import '../models/assistant_explanation.dart';

class ChatScreen extends GetView<ResultController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatScreenContent(controller: controller);
  }
}

class ChatScreenContent extends StatefulWidget {
  final ResultController controller;

  const ChatScreenContent({required this.controller, super.key});

  @override
  State<ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<ChatScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'chat_title'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Obx(() {
              final activeLogId = widget.controller.activeVerificationLogId;
              return Text(
                activeLogId > 0 ? 'chat_ref_log'.trParams({'id': '$activeLogId'}) : 'chat_fallback_title'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
              
                ),
              );
            }),
          ],
        ),
        centerTitle: false,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.refresh_rounded),
          //   // onPressed: widget.controller.clearChatMessages,
          //   tooltip: 'Clear chat',
          // ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Obx(() {
          final isLoading = widget.controller.isAssistantLoading.value;
          final error = widget.controller.assistantError.value;
          final messages = widget.controller.chatMessages;
          final canUseAssistant = widget.controller.canOpenAssistant;

          if (!canUseAssistant) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red.shade200, width: 2),
                    ),
                    child: Icon(
                      Icons.block_rounded,
                      color: Colors.red.shade600,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'chat_unavailable_title'.tr,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'chat_unavailable_desc'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Quick prompts
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Wrap(
                  spacing: 8,
                  children: widget.controller.quickPrompts().map((prompt) {
                    return ActionChip(
                      avatar: const Icon(Icons.flash_on, size: 14),
                      label: Text(prompt),
                      onPressed: isLoading
                          ? null
                          : () => widget.controller.useQuickPrompt(prompt),
                    );
                  }).toList(),
                ),
              ),

              // Messages
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBF5F0),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Color(0xFF1A6B4A),
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'chat_empty_title'.tr,
                              style: TextStyle(
                                color: Color(0xFF424242),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'chat_empty_desc'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: widget.controller.chatScrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        itemCount: messages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final message = messages[index];
                          return _chatBubble(message);
                        },
                      ),
              ),

              // Loading indicator
              if (isLoading) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'chat_thinking'.tr,
                        style: const TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Error message
              if (error != null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Input area
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: TextField(
                              controller: widget.controller.questionController,
                              minLines: 1,
                              maxLines: 4,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) {
                                if (!isLoading) {
                                  widget.controller.sendAssistantQuestion();
                                }
                              },
                              enabled: !isLoading,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'chat_input_hint'.tr,
                                hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () =>
                                      widget.controller.sendAssistantQuestion(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A3D2E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              disabledBackgroundColor: const Color(0xFFBDBDBD),
                            ),
                            child: const Icon(Icons.send_rounded, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _chatBubble(AssistantChatMessage message) {
    final isUser = message.isUser;
    final background = isUser ? const Color(0xFFDBEAFE) : Colors.grey.shade100;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final normalizedAction = message.recommendedAction.trim().toLowerCase();
    final stepsForDisplay = message.steps
        .where((step) => step.trim().toLowerCase() != normalizedAction)
        .toList();

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width * 0.8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'chat_assistant_label'.tr,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Text(
                message.text,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              if (!isUser && !message.related) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'chat_out_of_scope'.tr,
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              if (!isUser && message.recommendedAction.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'chat_recommended'.trParams({'action': message.recommendedAction}),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
              if (!isUser && stepsForDisplay.isNotEmpty) ...[
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: stepsForDisplay.map((step) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '• $step',
                        style: const TextStyle(fontSize: 12, height: 1.4),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
