import 'package:budidaya_lele_mobile/core/constants/app_assets.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum NotificationType { danger, warning }

class NotificationItem extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String message;
  final String timestamp;
  final bool isUnread;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isUnread = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: isUnread
            ? const EdgeInsets.only(bottom: 10)
            : const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 8, right: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        type == NotificationType.danger
                            ? Icons.report
                            : Icons.warning,
                        size: 14,
                        color: type == NotificationType.danger
                            ? AppColors.red
                            : AppColors.yellow,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timestamp,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
