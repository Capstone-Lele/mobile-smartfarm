import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
            ],
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
        backgroundColor: backgroundColor ?? AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          right: 20,
          left: 20,
        ),
        duration: duration,
      ),
    );
  }

  static void success(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: AppColors.green,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: AppColors.red,
      icon: Icons.error_outline,
    );
  }

  static void info(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline,
    );
  }

  static void warning(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_outlined,
    );
  }
}
