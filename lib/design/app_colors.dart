import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color background = Color(0xFFF8F6F1);
  static const Color surface = Colors.white;

  static const Color brandDeep = Color(0xFF0A3D2E);
  static const Color brand = Color(0xFF1A6B4A);
  static const Color accent = Color(0xFFD4AF37);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textMuted = Color(0xFF9E9E9E);

  static const Color success = Color(0xFF1A6B4A);
  static const Color caution = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);

  static const Color successBg = Color(0xFFECFDF5);
  static const Color cautionBg = Color(0xFFFFFBEB);
  static const Color dangerBg = Color(0xFFFEF2F2);

  static const Gradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandDeep, brand],
  );
}
