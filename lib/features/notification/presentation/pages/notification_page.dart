import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification.dart' as entity;
import 'package:budidaya_lele_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/widgets/notification_detail_modal.dart';
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
      final difference = DateTime(now.year, now.month, now.day)
          .difference(DateTime(date.year, date.month, date.day))
          .inDays;

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

  void _onNotificationTap(entity.Notification notification) {
    if (notification.readedAt == null) {
      ref.read(notificationMutationNotifierProvider.notifier).updateNotification(
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
            await ref.read(notificationListNotifierProvider.notifier).getNotifications();
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
                        final unreadToday = notifications.where((n) =>
                            _getGroupLabel(n.createdAt) == 'Hari ini' &&
                            n.readedAt == null).length;
                        return _buildHeader(context, unreadToday);
                      },
                      orElse: () => _buildHeader(context, 0),
                    ),
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
                    notificationsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stack) => Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(child: Text(error.toString())),
                      ),
                      data: (notifications) {
                        final filtered = notifications
                            .where((n) => n.category.toLowerCase() == categoryFilter)
                            .toList();

                        if (filtered.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(
                              child: Text(
                                'Tidak ada notifikasi',
                                style: TextStyle(color: AppColors.darkGray),
                              ),
                            ),
                          );
                        }

                        final Map<String, List<entity.Notification>> grouped = {
                          'Hari ini': [],
                          'Kemarin': [],
                          'Sebelumnya': [],
                        };

                        for (var n in filtered) {
                          final group = _getGroupLabel(n.createdAt);
                          grouped[group]?.add(n);
                        }

                        final List<Widget> listWidgets = [];

                        for (var group in ['Hari ini', 'Kemarin', 'Sebelumnya']) {
                          final groupItems = grouped[group]!;
                          if (groupItems.isNotEmpty) {
                            listWidgets.add(_buildSectionHeader(group));
                            for (var item in groupItems) {
                              listWidgets.add(
                                NotificationItem(
                                  type: item.type.toLowerCase() == 'danger'
                                      ? NotificationType.danger
                                      : NotificationType.warning,
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
