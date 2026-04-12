import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PoolConditionDetailList extends StatelessWidget {
  const PoolConditionDetailList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: AppColors.primary,
            child: const Text(
              'Detail Per Kolam',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          _buildItem('Kolam 1', '25.6°C', '7.2', 'Normal', BadgeType.success),
          const Divider(height: 1, color: AppColors.gray),
          _buildItem(
            'Kolam 2',
            '25.6°C',
            '7.5',
            'Peringatan',
            BadgeType.warning,
          ),
          const Divider(height: 1, color: AppColors.gray),
          _buildItem(
            'Kolam 3',
            '25.6°C',
            '8.1',
            'Perlu Dicek',
            BadgeType.danger,
          ),
          const Divider(height: 1, color: AppColors.gray),
          _buildItem('Kolam 4', '25.6°C', '7.2', 'Normal', BadgeType.success),
          const Divider(height: 1, color: AppColors.gray),
          _buildItem('Kolam 5', '25.6°C', '7.2', 'Normal', BadgeType.success),
          const Divider(height: 1, color: AppColors.gray),
          _buildItem('Kolam 6', '25.6°C', '7.2', 'Normal', BadgeType.success),
        ],
      ),
    );
  }

  Widget _buildItem(
    String name,
    String temp,
    String ph,
    String status,
    BadgeType type,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$temp | pH $ph',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 4),
              AppStatusBadge(label: status, type: type),
            ],
          ),
        ],
      ),
    );
  }
}
