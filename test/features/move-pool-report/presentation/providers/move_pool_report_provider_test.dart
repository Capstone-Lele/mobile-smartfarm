import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/entities/move_pool_report.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/repositories/move_pool_report_repository.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/usecases/get_move_pool_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/usecases/get_move_pool_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/presentation/providers/move_pool_report_provider.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeMovePoolReportRepository implements MovePoolReportRepository {
  Future<Either<Failure, List<MovePoolReport>>> Function(String)?
  _getListCallback;
  Future<Either<Failure, MovePoolReport>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    String,
    String,
    int,
    XFile,
    String?,
  )?
  _createCallback;

  void setupGetList(
    Future<Either<Failure, List<MovePoolReport>>> Function(String) callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, MovePoolReport>> Function(String) callback,
  ) => _getCallback = callback;

  void setupCreate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      String,
      String,
      int,
      XFile,
      String?,
    )
    callback,
  ) => _createCallback = callback;

  @override
  Future<Either<Failure, List<MovePoolReport>>> getMovePoolReports(
    String poolId,
  ) {
    if (_getListCallback != null) return _getListCallback!(poolId);
    return Future.value(Right<Failure, List<MovePoolReport>>([]));
  }

  @override
  Future<Either<Failure, MovePoolReport>> getMovePoolReport(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createMovePoolReport(
    String poolId,
    String originCycleId,
    String destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
    String? endedAt,
  ) {
    if (_createCallback != null) {
      return _createCallback!(
        poolId,
        originCycleId,
        destinationCycleId,
        reportDate,
        quantity,
        image,
        endedAt,
      );
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

class FakePoolRepository implements PoolRepository {
  Future<Either<Failure, List<Pool>>> Function()? _getPoolsCallback;
  Future<Either<Failure, PoolDetail>> Function(String)? _getPoolCallback;

  void setupGetPools(Future<Either<Failure, List<Pool>>> Function() callback) =>
      _getPoolsCallback = callback;

  void setupGetPool(
    Future<Either<Failure, PoolDetail>> Function(String) callback,
  ) => _getPoolCallback = callback;

  @override
  Future<Either<Failure, List<Pool>>> getPools() {
    if (_getPoolsCallback != null) return _getPoolsCallback!();
    return Future.value(Right<Failure, List<Pool>>([]));
  }

  @override
  Future<Either<Failure, PoolDetail>> getPool(String id) {
    if (_getPoolCallback != null) return _getPoolCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

MovePoolReport _makeReport({String id = 'move-1'}) => MovePoolReport(
  originPoolId: 'pool-1',
  originPoolName: 'Kolam A',
  originCategory: 'growing',
  destinationPoolId: 'pool-2',
  destinationPoolName: 'Kolam B',
  destinationCategory: 'growing',
  user: 'John Doe',
  id: id,
  originCycleId: 'cycle-1',
  destinationCycleId: 'cycle-2',
  userId: 'user-1',
  reportDate: '2024-07-01',
  quantity: 100,
  image: 'https://example.com/image.jpg',
  type: 'Pindah Kolam',
  createdAt: '2024-07-01T00:00:00.000Z',
  updatedAt: '2024-07-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeMovePoolReportRepository fakeRepository;
  late FakePoolRepository fakePoolRepository;

  setUp(() {
    fakeRepository = FakeMovePoolReportRepository();
    fakePoolRepository = FakePoolRepository();
  });

  group('MovePoolReportListNotifier', () {
    late MovePoolReportListNotifier notifier;

    setUp(() {
      notifier = MovePoolReportListNotifier(
        GetMovePoolReportsUsecase(fakeRepository),
      );
    });

    test('getMovePoolReports should return data on success', () async {
      // Arrange
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<MovePoolReport>>([_makeReport()]),
      );

      // Act
      await notifier.getMovePoolReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<List<MovePoolReport>>>());
      final data = (notifier.state as AsyncData<List<MovePoolReport>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'move-1');
      expect(data.first.originPoolName, 'Kolam A');
      expect(data.first.destinationPoolName, 'Kolam B');
    });

    test(
      'movePoolReportListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getMovePoolReportsUseCaseProvider.overrideWithValue(
              GetMovePoolReportsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(movePoolReportListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getMovePoolReports should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetList(
          (poolId) async => Left<Failure, List<MovePoolReport>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getMovePoolReports('pool-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('MovePoolReportDetailNotifier', () {
    late MovePoolReportDetailNotifier notifier;

    setUp(() {
      notifier = MovePoolReportDetailNotifier(
        GetMovePoolReportUsecase(fakeRepository),
      );
    });

    test('getMovePoolReport should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, MovePoolReport>(_makeReport()),
      );

      // Act
      await notifier.getMovePoolReport('move-1');

      // Assert
      expect(notifier.state, isA<AsyncData<MovePoolReport?>>());
      final detail = (notifier.state as AsyncData<MovePoolReport?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'move-1');
      expect(detail.originPoolName, 'Kolam A');
      expect(detail.destinationPoolName, 'Kolam B');
    });

    test(
      'movePoolReportDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getMovePoolReportUseCaseProvider.overrideWithValue(
              GetMovePoolReportUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(movePoolReportDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getMovePoolReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGet(
          (id) async =>
              Left<Failure, MovePoolReport>(FetchFailure('Network error')),
        );

        // Act
        await notifier.getMovePoolReport('move-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('MovePoolReportMutationNotifier', () {
    test('createMovePoolReport should return data on success', () async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          movePoolReportRepositoryProvider.overrideWithValue(fakeRepository),
          poolRepositoryProvider.overrideWithValue(fakePoolRepository),
        ],
      );

      fakeRepository.setupCreate(
        (
          poolId,
          originCycleId,
          destinationCycleId,
          reportDate,
          quantity,
          image,
          endedAt,
        ) async => Right<Failure, Map<String, dynamic>>({'id': 'move-new'}),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<MovePoolReport>>([]),
      );
      fakePoolRepository.setupGetPools(
        () async => Right<Failure, List<Pool>>([]),
      );
      fakePoolRepository.setupGetPool(
        (id) async => Left<Failure, PoolDetail>(FetchFailure('Not setup')),
      );

      final mutationNotifier = container.read(
        movePoolReportMutationNotifierProvider.notifier,
      );

      // Act
      await mutationNotifier.createMovePoolReport(
        'pool-1',
        'pool-2',
        'cycle-1',
        'cycle-2',
        '2024-07-01',
        100,
        XFile('image.jpg'),
        null,
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test(
      'createMovePoolReport should refresh list and pool after success',
      () async {
        // Arrange
        var listRefreshed = false;
        var poolsRefreshed = false;
        var poolDetailRefreshed = false;

        final container = ProviderContainer(
          overrides: [
            movePoolReportRepositoryProvider.overrideWithValue(fakeRepository),
            poolRepositoryProvider.overrideWithValue(fakePoolRepository),
          ],
        );

        fakeRepository.setupCreate(
          (
            poolId,
            originCycleId,
            destinationCycleId,
            reportDate,
            quantity,
            image,
            endedAt,
          ) async => Right<Failure, Map<String, dynamic>>({'id': 'move-new'}),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<MovePoolReport>>([]);
        });
        fakePoolRepository.setupGetPools(() async {
          poolsRefreshed = true;
          return Right<Failure, List<Pool>>([]);
        });
        fakePoolRepository.setupGetPool((id) async {
          poolDetailRefreshed = true;
          return Left<Failure, PoolDetail>(FetchFailure('Not setup'));
        });

        final mutationNotifier = container.read(
          movePoolReportMutationNotifierProvider.notifier,
        );

        // Act
        await mutationNotifier.createMovePoolReport(
          'pool-1',
          'pool-2',
          'cycle-1',
          'cycle-2',
          '2024-07-01',
          100,
          XFile('image.jpg'),
          null,
        );

        // Assert
        expect(listRefreshed, true);
        expect(poolsRefreshed, true);
        expect(poolDetailRefreshed, true);
      },
    );

    test(
      'createMovePoolReport should emit error state on network failure',
      () async {
        // Arrange
        final container = ProviderContainer(
          overrides: [
            movePoolReportRepositoryProvider.overrideWithValue(fakeRepository),
            poolRepositoryProvider.overrideWithValue(fakePoolRepository),
          ],
        );

        fakeRepository.setupCreate(
          (
            poolId,
            originCycleId,
            destinationCycleId,
            reportDate,
            quantity,
            image,
            endedAt,
          ) async => Left<Failure, Map<String, dynamic>>(
            FetchFailure('Network error'),
          ),
        );

        final mutationNotifier = container.read(
          movePoolReportMutationNotifierProvider.notifier,
        );

        // Act
        await mutationNotifier.createMovePoolReport(
          'pool-1',
          'pool-2',
          'cycle-1',
          'cycle-2',
          '2024-07-01',
          100,
          XFile('image.jpg'),
          null,
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
