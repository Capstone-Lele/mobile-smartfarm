import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/usecases/get_pool_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/usecases/get_pools_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report_detail.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/repositories/harvest_report_repository.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/usecases/create_harvest_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/usecases/get_harvest_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/usecases/get_harvest_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/providers/harvest_report_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeHarvestReportRepository implements HarvestReportRepository {
  Future<Either<Failure, List<HarvestReport>>> Function(String)?
  _getListCallback;
  Future<Either<Failure, HarvestReportDetail>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    int,
    int,
    XFile,
    String?,
  )?
  _createCallback;

  void setupGetList(
    Future<Either<Failure, List<HarvestReport>>> Function(String) callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, HarvestReportDetail>> Function(String) callback,
  ) => _getCallback = callback;

  void setupCreate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      int,
      int,
      XFile,
      String?,
    )
    callback,
  ) => _createCallback = callback;

  @override
  Future<Either<Failure, List<HarvestReport>>> getHarvestReports(
    String poolId,
  ) {
    if (_getListCallback != null) return _getListCallback!(poolId);
    return Future.value(Right<Failure, List<HarvestReport>>([]));
  }

  @override
  Future<Either<Failure, HarvestReportDetail>> getHarvestReport(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createHarvestReport(
    String cycleId,
    String reportDate,
    int totalKg,
    int amount,
    XFile image,
    String? endedAt,
  ) {
    if (_createCallback != null) {
      return _createCallback!(
        cycleId,
        reportDate,
        totalKg,
        amount,
        image,
        endedAt,
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

HarvestReport _makeReport({String id = 'harvest-1'}) => HarvestReport(
  id: id,
  date: '2024-06-15',
  userId: 'user-1',
  user: 'John Doe',
  cycleId: 'cycle-1',
  cycle: 'Siklus 1',
  cycleCondition: 'Selesai',
  poolId: 'pool-1',
  poolName: 'Kolam A',
  poolCategory: 'Lele',
  amount: 500,
  image: 'https://example.com/harvest.jpg',
  createdAt: '2024-06-15T00:00:00.000Z',
  updatedAt: '2024-06-15T00:00:00.000Z',
  deletedAt: null,
);

HarvestReportDetail _makeDetail({String id = 'harvest-1'}) =>
    HarvestReportDetail(
      userId: 'user-1',
      user: 'John Doe',
      id: id,
      cycleId: 'cycle-1',
      reportDate: '2024-06-15',
      totalKg: '50',
      amount: 500,
      image: 'https://example.com/harvest.jpg',
      createdAt: '2024-06-15T00:00:00.000Z',
      updatedAt: '2024-06-15T00:00:00.000Z',
      deletedAt: null,
    );

void main() {
  late FakeHarvestReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeHarvestReportRepository();
  });

  group('HarvestReportListNotifier', () {
    late HarvestReportListNotifier notifier;

    setUp(() {
      notifier = HarvestReportListNotifier(
        GetHarvestReportsUsecase(fakeRepository),
      );
    });

    test('getHarvestReports should return data on success', () async {
      // Arrange
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<HarvestReport>>([_makeReport()]),
      );

      // Act
      await notifier.getHarvestReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<List<HarvestReport>>>());
      final data = (notifier.state as AsyncData<List<HarvestReport>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'harvest-1');
      expect(data.first.amount, 500);
      expect(data.first.cycleCondition, 'Selesai');
    });

    test(
      'harvestReportListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getHarvestReportsUseCaseProvider.overrideWithValue(
              GetHarvestReportsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(harvestReportListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getHarvestReports should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetList(
          (poolId) async =>
              Left<Failure, List<HarvestReport>>(FetchFailure('Network error')),
        );

        // Act
        await notifier.getHarvestReports('pool-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('HarvestReportDetailNotifier', () {
    late HarvestReportDetailNotifier notifier;

    setUp(() {
      notifier = HarvestReportDetailNotifier(
        GetHarvestReportUsecase(fakeRepository),
      );
    });

    test('getHarvestReport should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, HarvestReportDetail>(_makeDetail()),
      );

      // Act
      await notifier.getHarvestReport('harvest-1');

      // Assert
      expect(notifier.state, isA<AsyncData<HarvestReportDetail?>>());
      final detail = (notifier.state as AsyncData<HarvestReportDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'harvest-1');
      expect(detail.amount, 500);
      expect(detail.reportDate, '2024-06-15');
    });

    test(
      'harvestReportDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getHarvestReportUseCaseProvider.overrideWithValue(
              GetHarvestReportUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(harvestReportDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getHarvestReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGet(
          (id) async =>
              Left<Failure, HarvestReportDetail>(FetchFailure('Network error')),
        );

        // Act
        await notifier.getHarvestReport('harvest-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('HarvestReportMutationNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          // Override harvest report usecases dengan fake repository
          createHarvestReportUseCaseProvider.overrideWithValue(
            CreateHarvestReportUsecase(fakeRepository),
          ),
          getHarvestReportsUseCaseProvider.overrideWithValue(
            GetHarvestReportsUsecase(fakeRepository),
          ),
          // Override pool usecases agar tidak melakukan network call
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

    test('createHarvestReport should return data on success', () async {
      // Arrange
      fakeRepository.setupCreate(
        (cycleId, reportDate, totalKg, amount, image, endedAt) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'harvest-new'}),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<HarvestReport>>([]),
      );

      // Act
      await container
          .read(harvestReportMutationNotifierProvider.notifier)
          .createHarvestReport(
            'pool-1',
            'cycle-1',
            '2024-06-15',
            100,
            500,
            XFile('harvest.jpg'),
            '2024-06-15',
          );

      // Assert
      final state = container.read(harvestReportMutationNotifierProvider);
      expect(state, isA<AsyncData<void>>());
    });

    test(
      'createHarvestReport should refresh harvest list after success',
      () async {
        // Arrange
        var listRefreshed = false;
        fakeRepository.setupCreate(
          (cycleId, reportDate, totalKg, amount, image, endedAt) async =>
              Right<Failure, Map<String, dynamic>>({'id': 'harvest-new'}),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<HarvestReport>>([_makeReport()]);
        });

        // Act
        await container
            .read(harvestReportMutationNotifierProvider.notifier)
            .createHarvestReport(
              'pool-1',
              'cycle-1',
              '2024-06-15',
              100,
              500,
              XFile('harvest.jpg'),
              null,
            );

        // Assert
        expect(listRefreshed, true);
      },
    );

    test(
      'createHarvestReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupCreate(
          (cycleId, reportDate, totalKg, amount, image, endedAt) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await container
            .read(harvestReportMutationNotifierProvider.notifier)
            .createHarvestReport(
              'pool-1',
              'cycle-1',
              '2024-06-15',
              100,
              500,
              XFile('harvest.jpg'),
              null,
            );

        // Assert
        final state = container.read(harvestReportMutationNotifierProvider);
        expect(state, isA<AsyncError>());
        final error = (state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
