import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../design/app_colors.dart';
import '../widgets/ll_ui.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreenContent(controller: controller);
  }
}

class SettingsScreenContent extends StatefulWidget {
  const SettingsScreenContent({required this.controller, super.key});

  final SettingsController controller;

  @override
  State<SettingsScreenContent> createState() => _SettingsScreenContentState();
}

class _SettingsScreenContentState extends State<SettingsScreenContent>
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
      headerHeight: 190,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const LlBackButton(),
              const SizedBox(height: 24),
              const LlTitleBlock(
                title: 'Settings',
                subtitle: 'Configure your application',
              ),
              const SizedBox(height: 28),
              LlSurfaceCard(
                padding: const EdgeInsets.all(20),
                radius: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.settings_rounded, color: AppColors.brand, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'API Configuration',
                          style: TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const LlFieldLabel('Base URL'),
                    const SizedBox(height: 8),
                    LlInputField(
                      controller: widget.controller.baseUrlController,
                      hint: 'http://10.0.2.2:8000',
                      icon: Icons.link_rounded,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.blue.shade700,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Android emulator: use http://10.0.2.2:8000',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              LlSurfaceCard(
                padding: const EdgeInsets.all(20),
                radius: 20,
                shadowOpacity: 0.06,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.language_rounded, color: AppColors.brand, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Language',
                          style: TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: widget.controller.selectedLanguage.value,
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'sw', child: Text('Swahili')),
                        ],
                        onChanged: widget.controller.setLanguage,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.translate_rounded,
                            color: Color(0xFF9E9E9E),
                            size: 18,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF212121),
                        ),
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => LlPrimaryButton(
                  label: 'Save Settings',
                  onPressed: widget.controller.saveSettings,
                  isLoading: widget.controller.isLoading.value,
                  icon: Icons.check_circle_rounded,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
