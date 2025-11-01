import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../ui/design_system/tokens/colors.dart';
import '../../../ui/design_system/tokens/typography.dart';

class AppToast {
  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context,
      message,
      backgroundColor: AppColors.primaryLight,
      textColor: Colors.white,
    );
  }

  static void showError(BuildContext context, String message) {
    _showToast(
      context,
      message,
      backgroundColor: Colors.black.withValues(alpha: 0.4),
      textColor: Colors.redAccent,
      isBlurred: true,
    );
  }

  static void _showToast(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required Color textColor,
    bool isBlurred = false,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (ctx) => Positioned(
            bottom: 100,
            left: 24,
            right: 24,
            child: BackdropFilter(
              filter:
                  isBlurred
                      ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                      : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }
}
