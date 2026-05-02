import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsBottomSheet extends ConsumerStatefulWidget {
  const NotificationSettingsBottomSheet({super.key});

  @override
  ConsumerState<NotificationSettingsBottomSheet> createState() =>
      _NotificationSettingsBottomSheetState();
}

class _NotificationSettingsBottomSheetState
    extends ConsumerState<NotificationSettingsBottomSheet> {
  void _onMarkAllAsRead() async {
    await ref
        .read(notificationMutationNotifierProvider.notifier)
        .updateNotifications(DateTime.now().toUtc().toIso8601String());

    final mutationState = ref.read(notificationMutationNotifierProvider);

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppRoutes.pop(context);
      AppSnackbar.success(
        'Semua notifikasi telah ditandai sebagai sudah dibaca',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(notificationMutationNotifierProvider).isLoading;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.gray),
          const SizedBox(height: 8),
          InkWell(
            onTap: isLoading ? null : _onMarkAllAsRead,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.visibility, color: AppColors.primary),
                  SizedBox(width: 12),
                  if (isLoading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(),
                    )
                  else
                    Text(
                      'Tandai Semua Sudah Dibaca',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
