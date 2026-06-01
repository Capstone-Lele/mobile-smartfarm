import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification.dart' as model;
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification_detail.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/usecases/update_notification_usecase.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/usecases/update_notifications_usecase.dart';
import 'package:budidaya_lele_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotificationRepository implements NotificationRepository {
  Future<Either<Failure, List<model.Notification>>> Function()? _getListCallback;
  Future<Either<Failure, NotificationDetail>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String)?
  _updateListCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String, String)?
  _updateCallback;

  void setupGetList(
    Future<Either<Failure, List<model.Notification>>> Function() callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, NotificationDetail>> Function(String) callback,
  ) => _getCallback = callback;

  void setupUpdateList(
    Future<Either<Failure, Map<String, dynamic>>> Function(String) callback,
  ) => _updateListCallback = callback;

  void setupUpdate(
    Future<Either<Failure, Map<String, dynamic>>> Function(String, String)
    callback,
  ) => _updateCallback = callback;

  @override
  Future<Either<Failure, List<model.Notification>>> getNotifications() {
    if (_getListCallback != null) return _getListCallback!();
    return Future.value(Right<Failure, List<model.Notification>>([]));
  }

  @override
  Future<Either<Failure, NotificationDetail>> getNotification(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateNotifications(
    String readedAt,
  ) {
    if (_updateListCallback != null) return _updateListCallback!(readedAt);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateNotification(
    String id,
    String readedAt,
  ) {
    if (_updateCallback != null) return _updateCallback!(id, readedAt);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

model.Notification _makeNotification({String id = 'notif-1'}) =>
    model.Notification(
      id: id,
      poolId: 'pool-1',
      userId: 'user-1',
      title: 'Perhatian Kolam',
      message: 'Suhu kolam tinggi',
      category: 'warning',
      type: 'sensor',
      readedAt: null,
      createdAt: '2024-08-01T00:00:00.000Z',
      deletedAt: null,
    );

NotificationDetail _makeDetail({String id = 'notif-1'}) => NotificationDetail(
  id: id,
  poolId: 'pool-1',
  userId: 'user-1',
  title: 'Perhatian Kolam',
  message: 'Suhu kolam tinggi',
  category: 'warning',
  type: 'sensor',
  readedAt: null,
  createdAt: '2024-08-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeNotificationRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeNotificationRepository();
  });

  group('NotificationListNotifier', () {
    late NotificationListNotifier notifier;

    setUp(() {
      notifier = NotificationListNotifier(
        GetNotificationsUsecase(fakeRepository),
      );
    });

    test('getNotifications should return data on success', () async {
      // Arrange
      fakeRepository.setupGetList(
        () async =>
            Right<Failure, List<model.Notification>>([_makeNotification()]),
      );

      // Act
      await notifier.getNotifications();

      // Assert
      expect(notifier.state, isA<AsyncData<List<model.Notification>>>());
      final data = (notifier.state as AsyncData<List<model.Notification>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'notif-1');
      expect(data.first.title, 'Perhatian Kolam');
    });

    test(
      'notificationListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getNotificationsUseCaseProvider.overrideWithValue(
              GetNotificationsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(notificationListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getNotifications should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetList(
          () async => Left<Failure, List<model.Notification>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getNotifications();

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('NotificationDetailNotifier', () {
    late NotificationDetailNotifier notifier;

    setUp(() {
      notifier = NotificationDetailNotifier(
        GetNotificationUsecase(fakeRepository),
      );
    });

    test('getNotification should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, NotificationDetail>(_makeDetail()),
      );

      // Act
      await notifier.getNotification('notif-1');

      // Assert
      expect(notifier.state, isA<AsyncData<NotificationDetail?>>());
      final detail = (notifier.state as AsyncData<NotificationDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'notif-1');
      expect(detail.title, 'Perhatian Kolam');
    });

    test(
      'notificationDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getNotificationUseCaseProvider.overrideWithValue(
              GetNotificationUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(notificationDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getNotification should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGet(
          (id) async => Left<Failure, NotificationDetail>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getNotification('notif-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('NotificationMutationNotifier', () {
    late NotificationListNotifier listNotifier;
    late NotificationDetailNotifier detailNotifier;
    late NotificationMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = NotificationListNotifier(
        GetNotificationsUsecase(fakeRepository),
      );
      detailNotifier = NotificationDetailNotifier(
        GetNotificationUsecase(fakeRepository),
      );
      mutationNotifier = NotificationMutationNotifier(
        UpdateNotificationsUsecase(fakeRepository),
        UpdateNotificationUsecase(fakeRepository),
        listNotifier,
        detailNotifier,
      );
    });

    test('updateNotifications should return data on success', () async {
      // Arrange
      fakeRepository.setupUpdateList(
        (readedAt) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Semua notifikasi dibaca',
        }),
      );
      fakeRepository.setupGetList(
        () async => Right<Failure, List<model.Notification>>([]),
      );

      // Act
      await mutationNotifier.updateNotifications('2024-08-01T01:00:00.000Z');

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('updateNotifications should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupUpdateList(
        (readedAt) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Semua notifikasi dibaca',
        }),
      );
      fakeRepository.setupGetList(( ) async {
        listRefreshed = true;
        return Right<Failure, List<model.Notification>>([]);
      });

      // Act
      await mutationNotifier.updateNotifications('2024-08-01T01:00:00.000Z');

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'updateNotifications should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupUpdateList(
          (readedAt) async => Left<Failure, Map<String, dynamic>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await mutationNotifier.updateNotifications('2024-08-01T01:00:00.000Z');

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('updateNotification should return data on success', () async {
      // Arrange
      fakeRepository.setupUpdate(
        (id, readedAt) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Notifikasi dibaca',
        }),
      );
      fakeRepository.setupGetList(
        () async => Right<Failure, List<model.Notification>>([]),
      );
      fakeRepository.setupGet(
        (id) async => Right<Failure, NotificationDetail>(_makeDetail()),
      );

      // Act
      await mutationNotifier.updateNotification(
        'notif-1',
        '2024-08-01T01:00:00.000Z',
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test(
      'updateNotification should refresh list and detail after success',
      () async {
        // Arrange
        var listRefreshed = false;
        var detailRefreshed = false;
        fakeRepository.setupUpdate(
          (id, readedAt) async => Right<Failure, Map<String, dynamic>>({
            'message': 'Notifikasi dibaca',
          }),
        );
        fakeRepository.setupGetList(( ) async {
          listRefreshed = true;
          return Right<Failure, List<model.Notification>>([]);
        });
        fakeRepository.setupGet((id) async {
          detailRefreshed = true;
          return Right<Failure, NotificationDetail>(_makeDetail());
        });

        // Act
        await mutationNotifier.updateNotification(
          'notif-1',
          '2024-08-01T01:00:00.000Z',
        );

        // Assert
        expect(listRefreshed, true);
        expect(detailRefreshed, true);
      },
    );

    test(
      'updateNotification should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupUpdate(
          (id, readedAt) async => Left<Failure, Map<String, dynamic>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await mutationNotifier.updateNotification(
          'notif-1',
          '2024-08-01T01:00:00.000Z',
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
