import 'package:flutter/material.dart';

import 'll_ui.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LlFieldLabel(label),
        const SizedBox(height: 8),
        LlInputField(
          controller: controller,
          hint: hint ?? '',
          icon: Icons.edit_rounded,
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
