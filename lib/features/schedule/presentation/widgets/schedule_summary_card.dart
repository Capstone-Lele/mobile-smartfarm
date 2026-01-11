import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ScheduleSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ScheduleSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.icon = Icons.access_time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      height: MediaQuery.of(context).size.width * 0.22,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkGray),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 10),
              Icon(icon, size: 26, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}
