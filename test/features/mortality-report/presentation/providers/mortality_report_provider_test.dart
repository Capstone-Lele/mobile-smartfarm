import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report_detail.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/repositories/mortality_report_repository.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/usecases/get_mortality_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/usecases/get_mortality_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/providers/mortality_report_provider.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeMortalityReportRepository implements MortalityReportRepository {
  Future<Either<Failure, List<MortalityReport>>> Function(String)?
  _getListCallback;
  Future<Either<Failure, MortalityReportDetail>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    String,
    int,
    XFile,
    String,
  )?
  _createCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    int,
    XFile?,
    String,
  )?
  _updateCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String)?
  _deleteCallback;

  void setupGetList(
    Future<Either<Failure, List<MortalityReport>>> Function(String) callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, MortalityReportDetail>> Function(String) callback,
  ) => _getCallback = callback;

  void setupCreate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      String,
      int,
      XFile,
      String,
    )
    callback,
  ) => _createCallback = callback;

  void setupUpdate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      int,
      XFile?,
      String,
    )
    callback,
  ) => _updateCallback = callback;

  void setupDelete(
    Future<Either<Failure, Map<String, dynamic>>> Function(String) callback,
  ) => _deleteCallback = callback;

  @override
  Future<Either<Failure, List<MortalityReport>>> getMortalityReports(
    String poolId,
  ) {
    if (_getListCallback != null) return _getListCallback!(poolId);
    return Future.value(Right<Failure, List<MortalityReport>>([]));
  }

  @override
  Future<Either<Failure, MortalityReportDetail>> getMortalityReport(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createMortalityReport(
    String cycleId,
    String userId,
    String reportDate,
    int quantity,
    XFile image,
    String notes,
  ) {
    if (_createCallback != null) {
      return _createCallback!(
        cycleId,
        userId,
        reportDate,
        quantity,
        image,
        notes,
      );
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateMortalityReport(
    String id,
    String reportDate,
    int quantity,
    XFile? image,
    String notes,
  ) {
    if (_updateCallback != null) {
      return _updateCallback!(id, reportDate, quantity, image, notes);
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteMortalityReport(
    String id,
  ) {
    if (_deleteCallback != null) return _deleteCallback!(id);
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

MortalityReport _makeReport({String id = 'mortality-1'}) => MortalityReport(
  userId: 'user-1',
  user: 'John Doe',
  poolId: 'pool-1',
  poolName: 'Kolam A',
  poolCategory: 'Lele',
  id: id,
  cycleId: 'cycle-1',
  reportDate: '2024-01-15',
  quantity: 5,
  image: 'https://example.com/image.jpg',
  notes: 'Kematian akibat penyakit',
  createdAt: '2024-01-15T00:00:00.000Z',
  updatedAt: '2024-01-15T00:00:00.000Z',
  deletedAt: null,
  cycleCondition: 'Aktif',
  cycle: 'Siklus 1',
);

MortalityReportDetail _makeDetail({String id = 'mortality-1'}) =>
    MortalityReportDetail(
      userId: 'user-1',
      user: 'John Doe',
      cycleCondition: 'Aktif',
      id: id,
      cycleId: 'cycle-1',
      reportDate: '2024-01-15',
      quantity: 5,
      image: 'https://example.com/image.jpg',
      notes: 'Kematian akibat penyakit',
      createdAt: '2024-01-15T00:00:00.000Z',
      updatedAt: '2024-01-15T00:00:00.000Z',
      deletedAt: null,
    );

void main() {
  late FakeMortalityReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeMortalityReportRepository();
  });

  group('MortalityReportListNotifier', () {
    late MortalityReportListNotifier notifier;

    setUp(() {
      notifier = MortalityReportListNotifier(
        GetMortalityReportsUsecase(fakeRepository),
      );
    });

    test('getMortalityReports should return data on success', () async {
      // Arrange
      final reports = [_makeReport()];
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<MortalityReport>>(reports),
      );

      // Act
      await notifier.getMortalityReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<List<MortalityReport>>>());
      final data = (notifier.state as AsyncData<List<MortalityReport>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'mortality-1');
      expect(data.first.quantity, 5);
    });

    test(
      'mortalityReportListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getMortalityReportsUseCaseProvider.overrideWithValue(
              GetMortalityReportsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(mortalityReportListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getMortalityReports should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetList(
          (poolId) async => Left<Failure, List<MortalityReport>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getMortalityReports('pool-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('MortalityReportDetailNotifier', () {
    late MortalityReportDetailNotifier notifier;

    setUp(() {
      notifier = MortalityReportDetailNotifier(
        GetMortalityReportUsecase(fakeRepository),
      );
    });

    test('getMortalityReport should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, MortalityReportDetail>(_makeDetail()),
      );

      // Act
      await notifier.getMortalityReport('mortality-1');

      // Assert
      expect(notifier.state, isA<AsyncData<MortalityReportDetail?>>());
      final detail =
          (notifier.state as AsyncData<MortalityReportDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'mortality-1');
      expect(detail.quantity, 5);
      expect(detail.notes, 'Kematian akibat penyakit');
    });

    test(
      'mortalityReportDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getMortalityReportUseCaseProvider.overrideWithValue(
              GetMortalityReportUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(mortalityReportDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getMortalityReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGet(
          (id) async => Left<Failure, MortalityReportDetail>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getMortalityReport('mortality-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('MortalityReportMutationNotifier', () {
    late FakePoolRepository fakePoolRepository;
    late ProviderContainer container;
    late MortalityReportMutationNotifier mutationNotifier;

    setUp(() {
      fakePoolRepository = FakePoolRepository();
      fakePoolRepository.setupGetPools(
        () async => Right<Failure, List<Pool>>([]),
      );
      fakePoolRepository.setupGetPool(
        (id) async => Left<Failure, PoolDetail>(FetchFailure('Not setup')),
      );

      container = ProviderContainer(
        overrides: [
          mortalityReportRepositoryProvider.overrideWithValue(fakeRepository),
          poolRepositoryProvider.overrideWithValue(fakePoolRepository),
        ],
      );

      mutationNotifier = container.read(
        mortalityReportMutationNotifierProvider.notifier,
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('createMortalityReport should return data on success', () async {
      // Arrange
      fakeRepository.setupCreate(
        (cycleId, userId, reportDate, quantity, image, notes) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'mortality-new'}),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<MortalityReport>>([]),
      );

      // Act
      await mutationNotifier.createMortalityReport(
        'pool-1',
        'cycle-1',
        'user-1',
        '2024-01-15',
        5,
        XFile('image.jpg'),
        'Kematian akibat penyakit',
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createMortalityReport should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupCreate(
        (cycleId, userId, reportDate, quantity, image, notes) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'mortality-new'}),
      );
      fakeRepository.setupGetList((poolId) async {
        listRefreshed = true;
        return Right<Failure, List<MortalityReport>>([_makeReport()]);
      });

      // Act
      await mutationNotifier.createMortalityReport(
        'pool-1',
        'cycle-1',
        'user-1',
        '2024-01-15',
        5,
        XFile('image.jpg'),
        'Kematian akibat penyakit',
      );

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'createMortalityReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupCreate(
          (cycleId, userId, reportDate, quantity, image, notes) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.createMortalityReport(
          'pool-1',
          'cycle-1',
          'user-1',
          '2024-01-15',
          5,
          XFile('image.jpg'),
          'Kematian akibat penyakit',
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('updateMortalityReport should return data on success', () async {
      // Arrange
      fakeRepository.setupUpdate(
        (id, reportDate, quantity, image, notes) async =>
            Right<Failure, Map<String, dynamic>>({
              'id': 'mortality-1',
              'reportDate': '2024-01-20',
            }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<MortalityReport>>([]),
      );
      fakeRepository.setupGet(
        (id) async => Right<Failure, MortalityReportDetail>(_makeDetail()),
      );

      // Act
      await mutationNotifier.updateMortalityReport(
        'mortality-1',
        'pool-1',
        '2024-01-20',
        3,
        null,
        'Kematian diperbarui',
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test(
      'updateMortalityReport should refresh list and detail after success',
      () async {
        // Arrange
        var listRefreshed = false;
        var detailRefreshed = false;
        fakeRepository.setupUpdate(
          (id, reportDate, quantity, image, notes) async =>
              Right<Failure, Map<String, dynamic>>({'id': 'mortality-1'}),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<MortalityReport>>([_makeReport()]);
        });
        fakeRepository.setupGet((id) async {
          detailRefreshed = true;
          return Right<Failure, MortalityReportDetail>(_makeDetail());
        });

        // Act
        await mutationNotifier.updateMortalityReport(
          'mortality-1',
          'pool-1',
          '2024-01-20',
          3,
          null,
          'Kematian diperbarui',
        );

        // Assert
        expect(listRefreshed, true);
        expect(detailRefreshed, true);
      },
    );

    test(
      'updateMortalityReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupUpdate(
          (id, reportDate, quantity, image, notes) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.updateMortalityReport(
          'mortality-1',
          'pool-1',
          '2024-01-20',
          3,
          null,
          'Kematian diperbarui',
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('deleteMortalityReport should return data on success', () async {
      // Arrange
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Laporan kematian berhasil dihapus',
        }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<MortalityReport>>([]),
      );

      // Act
      await mutationNotifier.deleteMortalityReport('mortality-1', 'pool-1');

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('deleteMortalityReport should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Laporan kematian berhasil dihapus',
        }),
      );
      fakeRepository.setupGetList((poolId) async {
        listRefreshed = true;
        return Right<Failure, List<MortalityReport>>([]);
      });

      // Act
      await mutationNotifier.deleteMortalityReport('mortality-1', 'pool-1');

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'deleteMortalityReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupDelete(
          (id) async => Left<Failure, Map<String, dynamic>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await mutationNotifier.deleteMortalityReport('mortality-1', 'pool-1');

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
