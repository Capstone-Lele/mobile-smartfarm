import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/widgets/notification_item.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/widgets/notification_settings_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final selectedCategoryIndex = ref.watch(selectedCategoryIndexProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  AppSegmentedControl(
                    children: const ['Sensor', 'Laporan', 'Pemeliharaan'],
                    selectedIndex: selectedCategoryIndex,
                    onValueChanged: (index) {
                      ref.read(selectedCategoryIndexProvider.notifier).state =
                          index;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Hari ini'),
                  const NotificationItem(
                    type: NotificationType.danger,
                    title: 'Bahaya pH',
                    message:
                        'Kritis! pH di Kolam 1 berada di angka 8.5. Ikan berisiko stres berat, segera netralisir air!',
                    timestamp: 'Senin, 29 September 2025 16:30',
                    isUnread: true,
                  ),
                  const NotificationItem(
                    type: NotificationType.warning,
                    title: 'Peringatan pH',
                    message:
                        'Waspada, pH Kolam 1 saat ini 7.5. Angka mulai menjauh dari batas ideal, mohon pantau secara berkala.',
                    timestamp: 'Senin, 29 September 2025 16:30',
                    isUnread: true,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Kemarin'),
                  const NotificationItem(
                    type: NotificationType.danger,
                    title: 'Bahaya Suhu',
                    message:
                        'Kritis! Suhu di Kolam 2 berada di angka 35°C. Ikan berisiko stres berat, segera netralisir air!',
                    timestamp: 'Senin, 25 September 2025 16:30',
                  ),
                  const NotificationItem(
                    type: NotificationType.warning,
                    title: 'Peringatan Suhu',
                    message:
                        'Waspada, Suhu Kolam 2 saat ini 34°C. Angka mulai menjauh dari batas ideal, mohon pantau secara berkala.',
                    timestamp: 'Senin, 25 September 2025 16:30',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Sebelumnya'),
                  const NotificationItem(
                    type: NotificationType.warning,
                    title: 'Peringatan Suhu',
                    message:
                        'Waspada, Suhu Kolam 2 saat ini 33°C. Angka mulai menjauh dari batas ideal, mohon pantau secara berkala.',
                    timestamp: 'Senin, 20 September 2025 16:30',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: AppColors.black,
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifikasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Anda memiliki',
                      style: TextStyle(color: AppColors.black, fontSize: 12),
                    ),
                    TextSpan(
                      text: ' 2 notifikasi',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(
                      text: ' hari ini',
                      style: TextStyle(color: AppColors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.darkGray,
              size: 50,
            ),
            onPressed: () => _showSettings(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const NotificationSettingsBottomSheet(),
    );
  }
}
