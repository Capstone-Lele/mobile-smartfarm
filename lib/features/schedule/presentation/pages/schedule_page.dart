import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/schedule_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/widgets/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/widgets/schedule_summary_card.dart';

class SchedulePage extends ConsumerWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String role = 'pic';
    final selectedTab = ref.watch(scheduleTabProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Menu Aplikasi",
                      style: TextStyle(fontSize: 14, color: AppColors.darkGray),
                    ),
                    Text(
                      "Jadwal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (role == 'pic') ...[
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      ScheduleSummaryCard(title: "Total Jadwal", value: "7"),
                      ScheduleSummaryCard(title: "Hari Ini", value: "4"),
                      ScheduleSummaryCard(title: "Mendatang", value: "3"),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                AppSegmentedControl(
                  selectedIndex: selectedTab,
                  children: const ["Pembersihan Kolam", "Pakan", "Sampling"],
                  onValueChanged: (index) {
                    ref.read(scheduleTabProvider.notifier).state = index;
                  },
                ),
                _buildSectionTitle('Hari ini'),
                ScheduleCard(
                  title: "Kolam 1",
                  description: "Pembersihan Kolam",
                  time: "Senin, 28 Okt 2025, 08:00",
                  officer: "Adib Firmansyah",
                  statusLabel: "Hari Ini",
                  statusType: BadgeType.success,
                ),
                _buildSectionTitle('Jadwal Mendatang'),
                ScheduleCard(
                  title: "Kolam 2",
                  description: "Pembersihan Kolam",
                  time: "Selasa, 29 Okt 2025, 08:00",
                  officer: "Dandy maulana",
                  statusLabel: "Mendatang",
                  statusType: BadgeType.warning,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: AppColors.secondary,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
        ),
      ),
    );
  }
}
