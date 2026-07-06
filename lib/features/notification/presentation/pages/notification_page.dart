// NOTE: Import cadangan untuk tombol generate token FCM (debugging).
// Uncomment bersama tombol & handler di bawah bila diperlukan.
// import 'package:budidaya_lele_mobile/common/services/fcm_service.dart';
// import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
// import 'package:budidaya_lele_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/widgets/notification_detail_modal.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/widgets/notification_item.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/widgets/notification_settings_bottom_sheet.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationListNotifierProvider.notifier).getNotifications();
    });
  }

  String _getGroupLabel(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final difference = DateTime(
        now.year,
        now.month,
        now.day,
      ).difference(DateTime(date.year, date.month, date.day)).inDays;

      if (difference == 0) {
        return 'Hari ini';
      } else if (difference == 1) {
        return 'Kemarin';
      } else {
        return 'Sebelumnya';
      }
    } catch (e) {
      return 'Sebelumnya';
    }
  }

  void _onNotificationTap(Notification notification) {
    if (notification.readedAt == null) {
      ref
          .read(notificationMutationNotifierProvider.notifier)
          .updateNotification(
            notification.id,
            DateTime.now().toUtc().toIso8601String(),
          );
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: NotificationDetailModal(notification: notification),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategoryIndex = ref.watch(selectedCategoryIndexProvider);
    final notificationsAsync = ref.watch(notificationListNotifierProvider);

    String categoryFilter;
    if (selectedCategoryIndex == 0) {
      categoryFilter = 'sensor';
    } else if (selectedCategoryIndex == 1) {
      categoryFilter = 'report';
    } else {
      categoryFilter = 'maintenance';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(notificationListNotifierProvider.notifier)
                .getNotifications();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    notificationsAsync.maybeWhen(
                      data: (notifications) {
                        final unreadToday = notifications
                            .where(
                              (n) =>
                                  _getGroupLabel(n.createdAt) == 'Hari ini' &&
                                  n.readedAt == null,
                            )
                            .length;
                        return _buildHeader(context, unreadToday);
                      },
                      orElse: () => _buildHeader(context, 0),
                    ),
                    const SizedBox(height: 16),
                    // NOTE: Tombol cadangan untuk generate token FCM baru
                    // (debugging notifikasi). Uncomment bersama handler
                    // `_regenerateToken` & import di atas bila diperlukan.
                    //
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: OutlinedButton.icon(
                    //     onPressed: () => _regenerateToken(),
                    //     icon: const Icon(Icons.refresh),
                    //     label: const Text('Generate Token FCM Baru'),
                    //   ),
                    // ),
                    // const SizedBox(height: 16),
                    AppSegmentedControl(
                      children: const ['Sensor', 'Laporan', 'Pemeliharaan'],
                      selectedIndex: selectedCategoryIndex,
                      onValueChanged: (index) {
                        ref.read(selectedCategoryIndexProvider.notifier).state =
                            index;
                      },
                    ),
                    const SizedBox(height: 16),
                    notificationsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stack) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text(error.toString())),
                      ),
                      data: (notifications) {
                        final filtered = notifications
                            .where(
                              (n) => n.category.toLowerCase() == categoryFilter,
                            )
                            .toList();

                        if (filtered.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'Tidak ada notifikasi',
                                style: TextStyle(color: AppColors.darkGray),
                              ),
                            ),
                          );
                        }

                        final Map<String, List<Notification>> grouped = {
                          'Hari ini': [],
                          'Kemarin': [],
                          'Sebelumnya': [],
                        };

                        for (var n in filtered) {
                          final group = _getGroupLabel(n.createdAt);
                          grouped[group]?.add(n);
                        }

                        final List<Widget> listWidgets = [];

                        for (var group in [
                          'Hari ini',
                          'Kemarin',
                          'Sebelumnya',
                        ]) {
                          final groupItems = grouped[group]!;
                          if (groupItems.isNotEmpty) {
                            listWidgets.add(_buildSectionHeader(group));
                            for (var item in groupItems) {
                              listWidgets.add(
                                NotificationItem(
                                  title: item.title,
                                  message: item.message,
                                  timestamp: AppFormat.dateTime(item.createdAt),
                                  isUnread: item.readedAt == null,
                                  onTap: () => _onNotificationTap(item),
                                ),
                              );
                            }
                            listWidgets.add(const SizedBox(height: 16));
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: listWidgets,
                        );
                      },
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int unreadTodayCount) {
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
                  fontSize: 18,
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
                      text: ' $unreadTodayCount notifikasi',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(
                      text: ' baru hari ini',
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
              size: 30,
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

  // NOTE: Handler cadangan untuk generate token FCM baru (debugging).
  // Uncomment bersama tombol di atas segmented control & import di atas.
  //
  // Future<void> _regenerateToken() async {
  //   AppSnackbar.info('Membuat token FCM baru...');
  //   final token = await FCMService.regenerateToken();
  //   if (token == null) {
  //     AppSnackbar.error('Gagal membuat token baru');
  //     return;
  //   }
  //   // ignore: avoid_print
  //   print('FCM Token (baru): $token');
  //   final deviceInfo = await FCMService.getDeviceInfo();
  //   await ref.read(registerTokenUseCaseProvider).execute(
  //         token,
  //         deviceInfo['name'] ?? 'Unknown Device',
  //         deviceInfo['type'] ?? 'android',
  //       );
  //   AppSnackbar.success('Token baru dibuat & didaftarkan. Cek log.');
  // }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const NotificationSettingsBottomSheet(),
    );
  }
}
