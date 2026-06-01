import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report_detail.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/repositories/feed_report_repository.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/create_feed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/delete_feed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/get_feed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/get_feed_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/update_feed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/feed-report/presentation/providers/feed_report_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeFeedReportRepository implements FeedReportRepository {
  Future<Either<Failure, List<FeedReport>>> Function(String)? _getListCallback;
  Future<Either<Failure, FeedReportDetail>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    String,
    int,
    XFile,
  )?
  _createCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    String,
    int,
    XFile?,
  )?
  _updateCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String)?
  _deleteCallback;

  void setupGetList(
    Future<Either<Failure, List<FeedReport>>> Function(String) callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, FeedReportDetail>> Function(String) callback,
  ) => _getCallback = callback;

  void setupCreate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      String,
      int,
      XFile,
    )
    callback,
  ) => _createCallback = callback;

  void setupUpdate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      String,
      int,
      XFile?,
    )
    callback,
  ) => _updateCallback = callback;

  void setupDelete(
    Future<Either<Failure, Map<String, dynamic>>> Function(String) callback,
  ) => _deleteCallback = callback;

  @override
  Future<Either<Failure, List<FeedReport>>> getFeedReports(String poolId) {
    if (_getListCallback != null) return _getListCallback!(poolId);
    return Future.value(Right<Failure, List<FeedReport>>([]));
  }

  @override
  Future<Either<Failure, FeedReportDetail>> getFeedReport(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createFeedReport(
    String cycleId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  ) {
    if (_createCallback != null) {
      return _createCallback!(cycleId, inventoryId, reportDate, quantity, image);
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateFeedReport(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile? image,
  ) {
    if (_updateCallback != null) {
      return _updateCallback!(id, inventoryId, reportDate, quantity, image);
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteFeedReport(String id) {
    if (_deleteCallback != null) return _deleteCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

FeedReport _makeReport({String id = 'feed-1'}) => FeedReport(
  poolId: 'pool-1',
  userId: 'user-1',
  user: 'John Doe',
  poolName: 'Kolam A',
  poolCategory: 'Lele',
  foodName: 'Pelet Pro',
  unit: 'kg',
  startDate: '2024-04-01',
  id: id,
  cycleId: 'cycle-1',
  inventoryId: 'inventory-1',
  type: 'Pelet',
  reportDate: '2024-04-10',
  quantity: '5',
  image: 'https://example.com/image.jpg',
  cycleCondition: 'Aktif',
  createdAt: '2024-04-10T00:00:00.000Z',
  updatedAt: '2024-04-10T00:00:00.000Z',
  deletedAt: null,
);

FeedReportDetail _makeDetail({String id = 'feed-1'}) => FeedReportDetail(
  userId: 'user-1',
  user: 'John Doe',
  foodName: 'Pelet Pro',
  unit: 'kg',
  id: id,
  cycleId: 'cycle-1',
  inventoryId: 'inventory-1',
  type: 'Pelet',
  reportDate: '2024-04-10',
  quantity: '5',
  image: 'https://example.com/image.jpg',
  cycleCondition: 'Aktif',
  createdAt: '2024-04-10T00:00:00.000Z',
  updatedAt: '2024-04-10T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeFeedReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeFeedReportRepository();
  });

  group('FeedReportListNotifier', () {
    late FeedReportListNotifier notifier;

    setUp(() {
      notifier = FeedReportListNotifier(
        GetFeedReportsUsecase(fakeRepository),
      );
    });

    test('getFeedReports should return data on success', () async {
      // Arrange
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<FeedReport>>([_makeReport()]),
      );

      // Act
      await notifier.getFeedReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<List<FeedReport>>>());
      final data = (notifier.state as AsyncData<List<FeedReport>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'feed-1');
      expect(data.first.foodName, 'Pelet Pro');
      expect(data.first.quantity, '5');
    });

    test(
      'feedReportListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getFeedReportsUseCaseProvider.overrideWithValue(
              GetFeedReportsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(feedReportListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getFeedReports should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetList(
          (poolId) async => Left<Failure, List<FeedReport>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getFeedReports('pool-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('FeedReportDetailNotifier', () {
    late FeedReportDetailNotifier notifier;

    setUp(() {
      notifier = FeedReportDetailNotifier(
        GetFeedReportUsecase(fakeRepository),
      );
    });

    test('getFeedReport should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, FeedReportDetail>(_makeDetail()),
      );

      // Act
      await notifier.getFeedReport('feed-1');

      // Assert
      expect(notifier.state, isA<AsyncData<FeedReportDetail?>>());
      final detail = (notifier.state as AsyncData<FeedReportDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'feed-1');
      expect(detail.foodName, 'Pelet Pro');
      expect(detail.quantity, '5');
      expect(detail.unit, 'kg');
    });

    test(
      'feedReportDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getFeedReportUseCaseProvider.overrideWithValue(
              GetFeedReportUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(feedReportDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getFeedReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGet(
          (id) async => Left<Failure, FeedReportDetail>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getFeedReport('feed-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('FeedReportMutationNotifier', () {
    late FeedReportListNotifier listNotifier;
    late FeedReportDetailNotifier detailNotifier;
    late FeedReportMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = FeedReportListNotifier(
        GetFeedReportsUsecase(fakeRepository),
      );
      detailNotifier = FeedReportDetailNotifier(
        GetFeedReportUsecase(fakeRepository),
      );
      mutationNotifier = FeedReportMutationNotifier(
        CreateFeedReportUsecase(fakeRepository),
        UpdateFeedReportUsecase(fakeRepository),
        DeleteFeedReportUsecase(fakeRepository),
        listNotifier,
        detailNotifier,
      );
    });

    test('createFeedReport should return data on success', () async {
      // Arrange
      fakeRepository.setupCreate(
        (cycleId, inventoryId, reportDate, quantity, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'feed-new'}),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<FeedReport>>([]),
      );

      // Act
      await mutationNotifier.createFeedReport(
        'pool-1',
        'cycle-1',
        'inventory-1',
        '2024-04-10',
        5,
        XFile('image.jpg'),
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createFeedReport should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupCreate(
        (cycleId, inventoryId, reportDate, quantity, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'feed-new'}),
      );
      fakeRepository.setupGetList((poolId) async {
        listRefreshed = true;
        return Right<Failure, List<FeedReport>>([_makeReport()]);
      });

      // Act
      await mutationNotifier.createFeedReport(
        'pool-1',
        'cycle-1',
        'inventory-1',
        '2024-04-10',
        5,
        XFile('image.jpg'),
      );

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'createFeedReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupCreate(
          (cycleId, inventoryId, reportDate, quantity, image) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.createFeedReport(
          'pool-1',
          'cycle-1',
          'inventory-1',
          '2024-04-10',
          5,
          XFile('image.jpg'),
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('updateFeedReport should return data on success', () async {
      // Arrange
      fakeRepository.setupUpdate(
        (id, inventoryId, reportDate, quantity, image) async =>
            Right<Failure, Map<String, dynamic>>({
              'id': 'feed-1',
              'reportDate': '2024-04-15',
            }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<FeedReport>>([]),
      );
      fakeRepository.setupGet(
        (id) async => Right<Failure, FeedReportDetail>(_makeDetail()),
      );

      // Act
      await mutationNotifier.updateFeedReport(
        'feed-1',
        'pool-1',
        'inventory-1',
        '2024-04-15',
        6,
        null,
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test(
      'updateFeedReport should refresh list and detail after success',
      () async {
        // Arrange
        var listRefreshed = false;
        var detailRefreshed = false;
        fakeRepository.setupUpdate(
          (id, inventoryId, reportDate, quantity, image) async =>
              Right<Failure, Map<String, dynamic>>({'id': 'feed-1'}),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<FeedReport>>([_makeReport()]);
        });
        fakeRepository.setupGet((id) async {
          detailRefreshed = true;
          return Right<Failure, FeedReportDetail>(_makeDetail());
        });

        // Act
        await mutationNotifier.updateFeedReport(
          'feed-1',
          'pool-1',
          'inventory-1',
          '2024-04-15',
          6,
          null,
        );

        // Assert
        expect(listRefreshed, true);
        expect(detailRefreshed, true);
      },
    );

    test(
      'updateFeedReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupUpdate(
          (id, inventoryId, reportDate, quantity, image) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.updateFeedReport(
          'feed-1',
          'pool-1',
          'inventory-1',
          '2024-04-15',
          6,
          null,
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('deleteFeedReport should return data on success', () async {
      // Arrange
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Laporan pakan berhasil dihapus',
        }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<FeedReport>>([]),
      );

      // Act
      await mutationNotifier.deleteFeedReport('feed-1', 'pool-1');

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('deleteFeedReport should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Laporan pakan berhasil dihapus',
        }),
      );
      fakeRepository.setupGetList((poolId) async {
        listRefreshed = true;
        return Right<Failure, List<FeedReport>>([]);
      });

      // Act
      await mutationNotifier.deleteFeedReport('feed-1', 'pool-1');

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'deleteFeedReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupDelete(
          (id) async => Left<Failure, Map<String, dynamic>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await mutationNotifier.deleteFeedReport('feed-1', 'pool-1');

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
