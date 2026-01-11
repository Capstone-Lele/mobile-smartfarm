import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class AppSnackbar {
  static void _showNotification({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    showOverlayNotification((context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }, duration: const Duration(seconds: 3));
  }

  static void success(String message) {
    _showNotification(
      message: message,
      backgroundColor: AppColors.green,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(String message) {
    _showNotification(
      message: message,
      backgroundColor: AppColors.red,
      icon: Icons.error_outline,
    );
  }

  static void info(String message) {
    _showNotification(
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline,
    );
  }

  static void warning(String message) {
    _showNotification(
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_outlined,
    );
  }
}
