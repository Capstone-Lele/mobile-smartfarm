import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum BadgeType { success, warning, danger }

class AppStatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;

  const AppStatusBadge({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (type) {
      case BadgeType.success:
        backgroundColor = AppColors.badgeSuccess.withValues(alpha: 0.1);
        textColor = AppColors.badgeTextSuccess;
        borderColor = AppColors.badgeSuccess.withValues(alpha: 0.2);
        break;
      case BadgeType.warning:
        backgroundColor = AppColors.badgeWarning.withValues(alpha: 0.1);
        textColor = AppColors.badgeTextWarning;
        borderColor = AppColors.badgeWarning.withValues(alpha: 0.2);
        break;
      case BadgeType.danger:
        backgroundColor = AppColors.badgeDanger.withValues(alpha: 0.1);
        textColor = AppColors.badgeTextDanger;
        borderColor = AppColors.badgeDanger.withValues(alpha: 0.2);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
