import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report_detail.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/repositories/pool_cleaning_report_repository.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/create_pool_cleaning_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/delete_pool_cleaning_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/get_pool_cleaning_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/get_pool_cleaning_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/update_pool_cleaning_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/providers/pool_cleaning_report_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakePoolCleaningReportRepository implements PoolCleaningReportRepository {
  Future<Either<Failure, List<PoolCleaningReport>>> Function(String)?
  _getListCallback;
  Future<Either<Failure, PoolCleaningReportDetail>> Function(String)?
  _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String, String, XFile)?
  _createCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    XFile?,
  )?
  _updateCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String)?
  _deleteCallback;

  void setupGetList(
    Future<Either<Failure, List<PoolCleaningReport>>> Function(String) callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, PoolCleaningReportDetail>> Function(String) callback,
  ) => _getCallback = callback;

  void setupCreate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      XFile,
    )
    callback,
  ) => _createCallback = callback;

  void setupUpdate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      XFile?,
    )
    callback,
  ) => _updateCallback = callback;

  void setupDelete(
    Future<Either<Failure, Map<String, dynamic>>> Function(String) callback,
  ) => _deleteCallback = callback;

  @override
  Future<Either<Failure, List<PoolCleaningReport>>> getPoolCleaningReports(
    String poolId,
  ) {
    if (_getListCallback != null) return _getListCallback!(poolId);
    return Future.value(Right<Failure, List<PoolCleaningReport>>([]));
  }

  @override
  Future<Either<Failure, PoolCleaningReportDetail>> getPoolCleaningReport(
    String id,
  ) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createPoolCleaningReport(
    String poolId,
    String reportDate,
    XFile image,
  ) {
    if (_createCallback != null) {
      return _createCallback!(poolId, reportDate, image);
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePoolCleaningReport(
    String id,
    String reportDate,
    XFile? image,
  ) {
    if (_updateCallback != null) {
      return _updateCallback!(id, reportDate, image);
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deletePoolCleaningReport(
    String id,
  ) {
    if (_deleteCallback != null) return _deleteCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

PoolCleaningReport _makeReport({String id = 'report-1'}) => PoolCleaningReport(
  userId: 'user-1',
  user: 'John Doe',
  poolName: 'Kolam A',
  poolCategory: 'Lele',
  id: id,
  poolId: 'pool-1',
  reportDate: '2024-01-15',
  image: 'https://example.com/image.jpg',
  createdAt: '2024-01-15T00:00:00.000Z',
  updatedAt: '2024-01-15T00:00:00.000Z',
  deletedAt: null,
);

PoolCleaningReportDetail _makeDetail({String id = 'report-1'}) =>
    PoolCleaningReportDetail(
      userId: 'user-1',
      user: 'John Doe',
      poolName: 'Kolam A',
      id: id,
      poolId: 'pool-1',
      reportDate: '2024-01-15',
      image: 'https://example.com/image.jpg',
      createdAt: '2024-01-15T00:00:00.000Z',
      updatedAt: '2024-01-15T00:00:00.000Z',
      deletedAt: null,
    );

void main() {
  late FakePoolCleaningReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakePoolCleaningReportRepository();
  });

  group('PoolCleaningReportListNotifier', () {
    late PoolCleaningReportListNotifier notifier;

    setUp(() {
      notifier = PoolCleaningReportListNotifier(
        GetPoolCleaningReportsUsecase(fakeRepository),
      );
    });

    test('getPoolCleaningReports should return data on success', () async {
      // Arrange
      final reports = [_makeReport()];
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<PoolCleaningReport>>(reports),
      );

      // Act
      await notifier.getPoolCleaningReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<List<PoolCleaningReport>>>());
      final data =
          (notifier.state as AsyncData<List<PoolCleaningReport>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'report-1');
    });

    test(
      'poolCleaningReportListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getPoolCleaningReportsUseCaseProvider.overrideWithValue(
              GetPoolCleaningReportsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(poolCleaningReportListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getPoolCleaningReports should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetList(
          (poolId) async => Left<Failure, List<PoolCleaningReport>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getPoolCleaningReports('pool-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('PoolCleaningReportDetailNotifier', () {
    late PoolCleaningReportDetailNotifier notifier;

    setUp(() {
      notifier = PoolCleaningReportDetailNotifier(
        GetPoolCleaningReportUsecase(fakeRepository),
      );
    });

    test('getPoolCleaningReport should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, PoolCleaningReportDetail>(_makeDetail()),
      );

      // Act
      await notifier.getPoolCleaningReport('report-1');

      // Assert
      expect(notifier.state, isA<AsyncData<PoolCleaningReportDetail?>>());
      final detail =
          (notifier.state as AsyncData<PoolCleaningReportDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'report-1');
      expect(detail.poolName, 'Kolam A');
    });

    test(
      'poolCleaningReportDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getPoolCleaningReportUseCaseProvider.overrideWithValue(
              GetPoolCleaningReportUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(poolCleaningReportDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getPoolCleaningReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGet(
          (id) async => Left<Failure, PoolCleaningReportDetail>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getPoolCleaningReport('report-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('PoolCleaningReportMutationNotifier', () {
    late PoolCleaningReportListNotifier listNotifier;
    late PoolCleaningReportDetailNotifier detailNotifier;
    late PoolCleaningReportMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = PoolCleaningReportListNotifier(
        GetPoolCleaningReportsUsecase(fakeRepository),
      );
      detailNotifier = PoolCleaningReportDetailNotifier(
        GetPoolCleaningReportUsecase(fakeRepository),
      );
      mutationNotifier = PoolCleaningReportMutationNotifier(
        CreatePoolCleaningReportUsecase(fakeRepository),
        UpdatePoolCleaningReportUsecase(fakeRepository),
        DeletePoolCleaningReportUsecase(fakeRepository),
        listNotifier,
        detailNotifier,
      );
    });

    test('createPoolCleaningReport should return data on success', () async {
      // Arrange
      fakeRepository.setupCreate(
        (poolId, reportDate, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'new-report'}),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<PoolCleaningReport>>([]),
      );

      // Act
      await mutationNotifier.createPoolCleaningReport(
        'pool-1',
        '2024-01-15',
        XFile('image.jpg'),
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test(
      'createPoolCleaningReport should refresh list after success',
      () async {
        // Arrange
        var listRefreshed = false;
        fakeRepository.setupCreate(
          (poolId, reportDate, image) async =>
              Right<Failure, Map<String, dynamic>>({'id': 'new-report'}),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<PoolCleaningReport>>([_makeReport()]);
        });

        // Act
        await mutationNotifier.createPoolCleaningReport(
          'pool-1',
          '2024-01-15',
          XFile('image.jpg'),
        );

        // Assert
        expect(listRefreshed, true);
      },
    );

    test(
      'createPoolCleaningReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupCreate(
          (poolId, reportDate, image) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.createPoolCleaningReport(
          'pool-1',
          '2024-01-15',
          XFile('image.jpg'),
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('updatePoolCleaningReport should return data on success', () async {
      // Arrange
      fakeRepository.setupUpdate(
        (id, reportDate, image) async => Right<Failure, Map<String, dynamic>>({
          'id': 'report-1',
          'reportDate': '2024-01-20',
        }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<PoolCleaningReport>>([]),
      );
      fakeRepository.setupGet(
        (id) async => Right<Failure, PoolCleaningReportDetail>(_makeDetail()),
      );

      // Act
      await mutationNotifier.updatePoolCleaningReport(
        'report-1',
        'pool-1',
        '2024-01-20',
        null,
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test(
      'updatePoolCleaningReport should refresh list and detail after success',
      () async {
        // Arrange
        var listRefreshed = false;
        var detailRefreshed = false;
        fakeRepository.setupUpdate(
          (id, reportDate, image) async =>
              Right<Failure, Map<String, dynamic>>({'id': 'report-1'}),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<PoolCleaningReport>>([_makeReport()]);
        });
        fakeRepository.setupGet((id) async {
          detailRefreshed = true;
          return Right<Failure, PoolCleaningReportDetail>(_makeDetail());
        });

        // Act
        await mutationNotifier.updatePoolCleaningReport(
          'report-1',
          'pool-1',
          '2024-01-20',
          null,
        );

        // Assert
        expect(listRefreshed, true);
        expect(detailRefreshed, true);
      },
    );

    test(
      'updatePoolCleaningReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupUpdate(
          (id, reportDate, image) async => Left<Failure, Map<String, dynamic>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await mutationNotifier.updatePoolCleaningReport(
          'report-1',
          'pool-1',
          '2024-01-20',
          null,
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('deletePoolCleaningReport should return data on success', () async {
      // Arrange
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Berhasil dihapus',
        }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<PoolCleaningReport>>([]),
      );

      // Act
      await mutationNotifier.deletePoolCleaningReport('report-1', 'pool-1');

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test(
      'deletePoolCleaningReport should refresh list after success',
      () async {
        // Arrange
        var listRefreshed = false;
        fakeRepository.setupDelete(
          (id) async => Right<Failure, Map<String, dynamic>>({
            'message': 'Berhasil dihapus',
          }),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<PoolCleaningReport>>([]);
        });

        // Act
        await mutationNotifier.deletePoolCleaningReport('report-1', 'pool-1');

        // Assert
        expect(listRefreshed, true);
      },
    );

    test(
      'deletePoolCleaningReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupDelete(
          (id) async => Left<Failure, Map<String, dynamic>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await mutationNotifier.deletePoolCleaningReport('report-1', 'pool-1');

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
