import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Single source of truth for verdict → UI style.
/// Risk score alone must NOT override an explicit DO_NOT_BUY / CAUTION verdict.
class VerdictStyle {
  const VerdictStyle({
    required this.code,
    required this.label,
    required this.color,
    required this.background,
    required this.icon,
  });

  final String code;
  final String label;
  final Color color;
  final Color background;
  final IconData icon;

  static VerdictStyle from({
    required String? verdictText,
    int? riskScore,
  }) {
    final raw = (verdictText ?? '').trim().toLowerCase().replaceAll('_', ' ');

    if (_isDoNotBuy(raw)) {
      return VerdictStyle(
        code: 'DO_NOT_BUY',
        label: 'verdict_do_not_buy'.tr,
        color: const Color(0xFFDC2626),
        background: const Color(0xFFFEF2F2),
        icon: Icons.cancel_rounded,
      );
    }

    if (raw.contains('caution') ||
        raw.contains('review') ||
        raw.contains('manual')) {
      return VerdictStyle(
        code: 'CAUTION',
        label: 'verdict_caution'.tr,
        color: const Color(0xFFD97706),
        background: const Color(0xFFFFFBEB),
        icon: Icons.warning_rounded,
      );
    }

    if (raw == 'safe' ||
        raw.contains('cleared') ||
        (raw.contains('pass') && !raw.contains('not'))) {
      return VerdictStyle(
        code: 'SAFE',
        label: 'verdict_safe'.tr,
        color: const Color(0xFF16A34A),
        background: const Color(0xFFECFDF5),
        icon: Icons.check_circle_rounded,
      );
    }

    // Fallback only when verdict text is missing/unknown.
    final risk = riskScore ?? 100;
    if (risk <= 29) {
      return VerdictStyle(
        code: 'SAFE',
        label: 'verdict_safe'.tr,
        color: const Color(0xFF16A34A),
        background: const Color(0xFFECFDF5),
        icon: Icons.check_circle_rounded,
      );
    }
    if (risk <= 69) {
      return VerdictStyle(
        code: 'CAUTION',
        label: 'verdict_caution'.tr,
        color: const Color(0xFFD97706),
        background: const Color(0xFFFFFBEB),
        icon: Icons.warning_rounded,
      );
    }

    return VerdictStyle(
      code: 'DO_NOT_BUY',
      label: 'verdict_do_not_buy'.tr,
      color: const Color(0xFFDC2626),
      background: const Color(0xFFFEF2F2),
      icon: Icons.cancel_rounded,
    );
  }

  static bool _isDoNotBuy(String raw) {
    return raw.contains('do not buy') ||
        raw.contains('dont buy') ||
        raw.contains("don't buy") ||
        raw.contains('donotbuy') ||
        raw.contains('blocked') ||
        raw.contains('reject') ||
        raw.contains('fraud') ||
        raw == 'fail' ||
        raw.contains('failed');
  }
}
