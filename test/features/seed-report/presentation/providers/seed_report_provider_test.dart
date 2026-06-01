import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/usecases/get_pool_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/usecases/get_pools_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report_detail.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/repositories/seed_report_repository.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/usecases/create_seed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/usecases/get_seed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/usecases/get_seed_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/seed-report/presentation/providers/seed_report_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeSeedReportRepository implements SeedReportRepository {
  Future<Either<Failure, List<SeedReport>>> Function(String)? _getListCallback;
  Future<Either<Failure, SeedReportDetail>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    String,
    int,
    int,
    double,
    XFile,
  )?
  _createCallback;

  void setupGetList(
    Future<Either<Failure, List<SeedReport>>> Function(String) callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, SeedReportDetail>> Function(String) callback,
  ) => _getCallback = callback;

  void setupCreate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      String,
      int,
      int,
      double,
      XFile,
    )
    callback,
  ) => _createCallback = callback;

  @override
  Future<Either<Failure, List<SeedReport>>> getSeedReports(String poolId) {
    if (_getListCallback != null) return _getListCallback!(poolId);
    return Future.value(Right<Failure, List<SeedReport>>([]));
  }

  @override
  Future<Either<Failure, SeedReportDetail>> getSeedReport(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSeedReport(
    String poolId,
    String userId,
    String reportDate,
    int initialQuantity,
    int currentQuantity,
    double initialAverageWeight,
    XFile image,
  ) {
    if (_createCallback != null) {
      return _createCallback!(
        poolId,
        userId,
        reportDate,
        initialQuantity,
        currentQuantity,
        initialAverageWeight,
        image,
      );
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

class _FakePoolRepository implements PoolRepository {
  @override
  Future<Either<Failure, List<Pool>>> getPools() async =>
      Right<Failure, List<Pool>>([]);

  @override
  Future<Either<Failure, PoolDetail>> getPool(String id) async =>
      Left<Failure, PoolDetail>(FetchFailure('Not needed in test'));
}

SeedReport _makeReport({String id = 'seed-1'}) => SeedReport(
  user: 'John Doe',
  poolName: 'Kolam A',
  poolCategory: 'Lele',
  id: id,
  poolId: 'pool-1',
  userId: 'user-1',
  reportDate: '2024-01-15',
  initialQuantity: 1000,
  currentQuantity: 950,
  initialAverageWeight: '2.5',
  image: 'https://example.com/image.jpg',
  condition: 'Baik',
  createdAt: '2024-01-15T00:00:00.000Z',
  updatedAt: '2024-01-15T00:00:00.000Z',
  deletedAt: null,
);

SeedReportDetail _makeDetail({String id = 'seed-1'}) => SeedReportDetail(
  id: id,
  poolId: 'pool-1',
  userId: 'user-1',
  reportDate: '2024-01-15',
  initialQuantity: 1000,
  currentQuantity: 950,
  initialAverageWeight: '2.5',
  image: 'https://example.com/image.jpg',
  condition: 'Baik',
  createdAt: '2024-01-15T00:00:00.000Z',
  updatedAt: '2024-01-15T00:00:00.000Z',
  deletedAt: null,
  user: 'John Doe',
);

void main() {
  late FakeSeedReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeSeedReportRepository();
  });

  group('SeedReportListNotifier', () {
    late SeedReportListNotifier notifier;

    setUp(() {
      notifier = SeedReportListNotifier(GetSeedReportsUsecase(fakeRepository));
    });

    test('getSeedReports should return data on success', () async {
      // Arrange
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<SeedReport>>([_makeReport()]),
      );

      // Act
      await notifier.getSeedReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<List<SeedReport>>>());
      final data = (notifier.state as AsyncData<List<SeedReport>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'seed-1');
      expect(data.first.initialQuantity, 1000);
      expect(data.first.currentQuantity, 950);
    });

    test(
      'seedReportListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getSeedReportsUseCaseProvider.overrideWithValue(
              GetSeedReportsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(seedReportListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test('getSeedReports should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupGetList(
        (poolId) async =>
            Left<Failure, List<SeedReport>>(FetchFailure('Network error')),
      );

      // Act
      await notifier.getSeedReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('SeedReportDetailNotifier', () {
    late SeedReportDetailNotifier notifier;

    setUp(() {
      notifier = SeedReportDetailNotifier(GetSeedReportUsecase(fakeRepository));
    });

    test('getSeedReport should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, SeedReportDetail>(_makeDetail()),
      );

      // Act
      await notifier.getSeedReport('seed-1');

      // Assert
      expect(notifier.state, isA<AsyncData<SeedReportDetail?>>());
      final detail = (notifier.state as AsyncData<SeedReportDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'seed-1');
      expect(detail.initialQuantity, 1000);
      expect(detail.initialAverageWeight, '2.5');
      expect(detail.condition, 'Baik');
    });

    test(
      'seedReportDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getSeedReportUseCaseProvider.overrideWithValue(
              GetSeedReportUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(seedReportDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test('getSeedReport should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async =>
            Left<Failure, SeedReportDetail>(FetchFailure('Network error')),
      );

      // Act
      await notifier.getSeedReport('seed-1');

      // Assert
      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('SeedReportMutationNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          createSeedReportUseCaseProvider.overrideWithValue(
            CreateSeedReportUsecase(fakeRepository),
          ),
          getSeedReportsUseCaseProvider.overrideWithValue(
            GetSeedReportsUsecase(fakeRepository),
          ),
          getPoolsUseCaseProvider.overrideWithValue(
            GetPoolsUsecase(_FakePoolRepository()),
          ),
          getPoolUseCaseProvider.overrideWithValue(
            GetPoolUsecase(_FakePoolRepository()),
          ),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('createSeedReport should return data on success', () async {
      // Arrange
      fakeRepository.setupCreate(
        (poolId, userId, reportDate, iq, cq, iaw, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'seed-new'}),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<SeedReport>>([]),
      );

      // Act
      await container
          .read(seedReportMutationNotifierProvider.notifier)
          .createSeedReport(
            'pool-1',
            'user-1',
            '2024-01-15',
            1000,
            950,
            2.5,
            XFile('image.jpg'),
          );

      // Assert
      final state = container.read(seedReportMutationNotifierProvider);
      expect(state, isA<AsyncData<void>>());
    });

    test(
      'createSeedReport should refresh seed report list after success',
      () async {
        // Arrange
        var listRefreshed = false;
        fakeRepository.setupCreate(
          (poolId, userId, reportDate, iq, cq, iaw, image) async =>
              Right<Failure, Map<String, dynamic>>({'id': 'seed-new'}),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<SeedReport>>([_makeReport()]);
        });

        // Act
        await container
            .read(seedReportMutationNotifierProvider.notifier)
            .createSeedReport(
              'pool-1',
              'user-1',
              '2024-01-15',
              1000,
              950,
              2.5,
              XFile('image.jpg'),
            );

        // Assert
        expect(listRefreshed, true);
      },
    );

    test(
      'createSeedReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupCreate(
          (poolId, userId, reportDate, iq, cq, iaw, image) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await container
            .read(seedReportMutationNotifierProvider.notifier)
            .createSeedReport(
              'pool-1',
              'user-1',
              '2024-01-15',
              1000,
              950,
              2.5,
              XFile('image.jpg'),
            );

        // Assert
        final state = container.read(seedReportMutationNotifierProvider);
        expect(state, isA<AsyncError>());
        final error = (state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
