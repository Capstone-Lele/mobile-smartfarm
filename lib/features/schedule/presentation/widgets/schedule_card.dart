import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String officer;
  final String statusLabel;
  final BadgeType statusType;
  final bool isPic;

  const ScheduleCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.officer,
    required this.statusLabel,
    required this.statusType,
    required this.isPic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPic ? AppColors.lightGray : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.water_drop_outlined,
                    size: 26,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              AppStatusBadge(label: statusLabel, type: statusType),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                "Waktu: $time",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Petugas: $officer",
            style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
          ),
        ],
      ),
    );
  }
}
