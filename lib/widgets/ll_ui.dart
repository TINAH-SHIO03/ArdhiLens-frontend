import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/storage_service.dart';
import '../design/app_colors.dart';
import '../routes/app_routes.dart';

class LlHeaderShell extends StatelessWidget {
  const LlHeaderShell({
    super.key,
    required this.child,
    this.headerHeight = 200,
    this.horizontalPadding = 24,
    this.backgroundColor = AppColors.background,
  });

  final Widget child;
  final double headerHeight;
  final double horizontalPadding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: headerHeight,
              decoration: const BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
          ),
          Positioned(
            top: -48,
            right: -36,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class LlBackButton extends StatelessWidget {
  const LlBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LlActionIconButton(
      icon: Icons.arrow_back_ios_new_rounded,
      onTap: onTap ?? () => _defaultBack(context),
      backgroundColor: Colors.white.withValues(alpha: 0.22),
      iconColor: Colors.white,
      size: 48,
      iconSize: 18,
    );
  }

  static void _defaultBack(BuildContext context) {
    final rootNav = Get.key.currentState;
    if (rootNav != null && rootNav.canPop()) {
      Get.back();
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    try {
      final storage = Get.find<StorageService>();
      if (storage.isAuthenticated) {
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.landing);
      }
    } catch (_) {
      Get.offAllNamed(Routes.landing);
    }
  }
}

class LlActionIconButton extends StatelessWidget {
  const LlActionIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.loading = false,
    this.backgroundColor,
    this.iconColor,
    this.size = 38,
    this.iconSize = 20,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool loading;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color:
                backgroundColor ?? Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (iconColor ?? Colors.white).withValues(alpha: 0.35),
            ),
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: iconSize - 2,
                    height: iconSize - 2,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: iconColor ?? Colors.white,
                    ),
                  )
                : Icon(icon, color: iconColor ?? Colors.white, size: iconSize),
          ),
        ),
      ),
    );
  }
}

class LlStepBadge extends StatelessWidget {
  const LlStepBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class LlTitleBlock extends StatelessWidget {
  const LlTitleBlock({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class LlSurfaceCard extends StatelessWidget {
  const LlSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = 24,
    this.shadowOpacity = 0.08,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double shadowOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: shadowOpacity),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class LlFieldLabel extends StatelessWidget {
  const LlFieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF424242),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}

class LlInputField extends StatelessWidget {
  const LlInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
    this.minLines,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF212121),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF9E9E9E), size: 20),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 24),
        counterText: maxLength == null ? null : '',
      ),
    );
  }
}

class LlErrorBanner extends StatelessWidget {
  const LlErrorBanner({
    super.key,
    required this.message,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  final String message;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200, width: 1),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.red.shade700,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class LlPrimaryButton extends StatelessWidget {
  const LlPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon = Icons.arrow_forward_rounded,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(icon, size: 18),
                ],
              ),
      ),
    );
  }
}
