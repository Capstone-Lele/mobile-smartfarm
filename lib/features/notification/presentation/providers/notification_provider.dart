import 'package:budidaya_lele_mobile/features/notification/data/datasources/notification_datasource.dart';
import 'package:budidaya_lele_mobile/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification_detail.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/usecases/update_notification_usecase.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/usecases/update_notifications_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final selectedCategoryIndexProvider = StateProvider<int>((ref) => 0);

// Provider Datasource
final notificationDatasourceProvider = Provider(
  (ref) => NotificationDatasource(),
);

// Provider Repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final datasource = ref.read(notificationDatasourceProvider);
  return NotificationRepositoryImpl(datasource);
});

// Provider Usecase
final getNotificationsUseCaseProvider = Provider<GetNotificationsUsecase>((
  ref,
) {
  final repository = ref.read(notificationRepositoryProvider);
  return GetNotificationsUsecase(repository);
});

final getNotificationUseCaseProvider = Provider<GetNotificationUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return GetNotificationUsecase(repository);
});

final updateNotificationsUseCaseProvider = Provider<UpdateNotificationsUsecase>(
  (ref) {
    final repository = ref.read(notificationRepositoryProvider);
    return UpdateNotificationsUsecase(repository);
  },
);

final updateNotificationUseCaseProvider = Provider<UpdateNotificationUsecase>((
  ref,
) {
  final repository = ref.read(notificationRepositoryProvider);
  return UpdateNotificationUsecase(repository);
});

class NotificationListNotifier
    extends StateNotifier<AsyncValue<List<Notification>>> {
  final GetNotificationsUsecase _getNotificationsUsecase;

  NotificationListNotifier(this._getNotificationsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getNotifications() async {
    state = const AsyncValue.loading();
    final result = await _getNotificationsUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (notifications) {
        state = AsyncValue.data(notifications);
      },
    );
  }
}

class NotificationDetailNotifier
    extends StateNotifier<AsyncValue<NotificationDetail?>> {
  final GetNotificationUsecase _getNotificationUsecase;

  NotificationDetailNotifier(this._getNotificationUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getNotification(String id) async {
    state = const AsyncValue.loading();
    final result = await _getNotificationUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (notification) {
        state = AsyncValue.data(notification);
      },
    );
  }
}

class NotificationMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final UpdateNotificationsUsecase _updateNotificationsUsecase;
  final UpdateNotificationUsecase _updateNotificationUsecase;
  final NotificationListNotifier _listNotifier;
  final NotificationDetailNotifier _detailNotifier;

  NotificationMutationNotifier(
    this._updateNotificationsUsecase,
    this._updateNotificationUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Update notifications all
  Future<void> updateNotifications(String readedAt) async {
    state = const AsyncValue.loading();
    final result = await _updateNotificationsUsecase.execute(readedAt);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah notifikasi',
          StackTrace.current,
        );
      },
      (notification) {
        state = AsyncValue.data(null);
        _listNotifier.getNotifications();
      },
    );
  }

  // Update notification by id
  Future<void> updateNotification(String id, String readedAt) async {
    state = const AsyncValue.loading();
    final result = await _updateNotificationUsecase.execute(id, readedAt);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah notifikasi',
          StackTrace.current,
        );
      },
      (notification) {
        state = AsyncValue.data(null);
        _listNotifier.getNotifications();
        _detailNotifier.getNotification(id);
      },
    );
  }
}

// provider Utama
// Notification List Notifier Provider
final notificationListNotifierProvider =
    StateNotifierProvider<
      NotificationListNotifier,
      AsyncValue<List<Notification>>
    >((ref) {
      final getNotificationsUsecase = ref.read(getNotificationsUseCaseProvider);

      return NotificationListNotifier(getNotificationsUsecase);
    });

// Notification Detail Notifier Provider
final notificationDetailNotifierProvider =
    StateNotifierProvider<
      NotificationDetailNotifier,
      AsyncValue<NotificationDetail?>
    >((ref) {
      final getNotificationUsecase = ref.read(getNotificationUseCaseProvider);
      return NotificationDetailNotifier(getNotificationUsecase);
    });

// Notification Mutation Notifier Provider
final notificationMutationNotifierProvider =
    StateNotifierProvider<NotificationMutationNotifier, AsyncValue<void>>((
      ref,
    ) {
      final updateNotificationsUsecase = ref.read(
        updateNotificationsUseCaseProvider,
      );

      final updateNotificationUsecase = ref.read(
        updateNotificationUseCaseProvider,
      );

      final listNotifier = ref.read(notificationListNotifierProvider.notifier);
      final detailNotifier = ref.read(
        notificationDetailNotifierProvider.notifier,
      );

      return NotificationMutationNotifier(
        updateNotificationsUsecase,
        updateNotificationUsecase,
        listNotifier,
        detailNotifier,
      );
    });
