import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class InventorySubmissionCard extends StatelessWidget {
  final String productName;
  final String quantity;
  final String submissionDate;
  final String status;
  final BadgeType badgeType;
  final VoidCallback? onTap;

  const InventorySubmissionCard({
    super.key,
    required this.productName,
    required this.quantity,
    required this.submissionDate,
    required this.status,
    required this.badgeType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkGray, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Symbols.package_2, color: Colors.black, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                AppStatusBadge(label: status, type: badgeType),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    quantity,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Diajukan: $submissionDate',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
