import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report_detail.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/repositories/sampling_report_repository.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/create_sampling_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/delete_sampling_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/get_sampling_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/get_sampling_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/update_sampling_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/providers/sampling_report_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeSamplingReportRepository implements SamplingReportRepository {
  Future<Either<Failure, List<SamplingReport>>> Function(String)?
  _getListCallback;
  Future<Either<Failure, SamplingReportDetail>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    int,
    double,
    XFile,
  )?
  _createCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    int,
    double,
    XFile?,
  )?
  _updateCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String)?
  _deleteCallback;

  void setupGetList(
    Future<Either<Failure, List<SamplingReport>>> Function(String) callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, SamplingReportDetail>> Function(String) callback,
  ) => _getCallback = callback;

  void setupCreate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      int,
      double,
      XFile,
    )
    callback,
  ) => _createCallback = callback;

  void setupUpdate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      int,
      double,
      XFile?,
    )
    callback,
  ) => _updateCallback = callback;

  void setupDelete(
    Future<Either<Failure, Map<String, dynamic>>> Function(String) callback,
  ) => _deleteCallback = callback;

  @override
  Future<Either<Failure, List<SamplingReport>>> getSamplingReports(
    String poolId,
  ) {
    if (_getListCallback != null) return _getListCallback!(poolId);
    return Future.value(Right<Failure, List<SamplingReport>>([]));
  }

  @override
  Future<Either<Failure, SamplingReportDetail>> getSamplingReport(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSamplingReport(
    String cycleId,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile image,
  ) {
    if (_createCallback != null) {
      return _createCallback!(
        cycleId,
        reportDate,
        quantity,
        averageWeight,
        image,
      );
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateSamplingReport(
    String id,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile? image,
  ) {
    if (_updateCallback != null) {
      return _updateCallback!(id, reportDate, quantity, averageWeight, image);
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteSamplingReport(
    String id,
  ) {
    if (_deleteCallback != null) return _deleteCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

SamplingReport _makeReport({String id = 'sampling-1'}) => SamplingReport(
  userId: 'user-1',
  user: 'John Doe',
  poolId: 'pool-1',
  poolName: 'Kolam A',
  poolCategory: 'Lele',
  cycleCondition: 'Aktif',
  id: id,
  cycleId: 'cycle-1',
  reportDate: '2024-03-10',
  quantity: 50,
  averageWeight: '150.5',
  image: 'https://example.com/image.jpg',
  createdAt: '2024-03-10T00:00:00.000Z',
  updatedAt: '2024-03-10T00:00:00.000Z',
  deletedAt: null,
);

SamplingReportDetail _makeDetail({String id = 'sampling-1'}) =>
    SamplingReportDetail(
      userId: 'user-1',
      user: 'John Doe',
      poolName: 'Kolam A',
      cycleCondition: 'Aktif',
      id: id,
      cycleId: 'cycle-1',
      reportDate: '2024-03-10',
      quantity: 50,
      averageWeight: '150.5',
      image: 'https://example.com/image.jpg',
      createdAt: '2024-03-10T00:00:00.000Z',
      updatedAt: '2024-03-10T00:00:00.000Z',
      deletedAt: null,
    );

void main() {
  late FakeSamplingReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeSamplingReportRepository();
  });

  group('SamplingReportListNotifier', () {
    late SamplingReportListNotifier notifier;

    setUp(() {
      notifier = SamplingReportListNotifier(
        GetSamplingReportsUsecase(fakeRepository),
      );
    });

    test('getSamplingReports should return data on success', () async {
      // Arrange
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<SamplingReport>>([_makeReport()]),
      );

      // Act
      await notifier.getSamplingReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<List<SamplingReport>>>());
      final data = (notifier.state as AsyncData<List<SamplingReport>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'sampling-1');
      expect(data.first.quantity, 50);
      expect(data.first.averageWeight, '150.5');
    });

    test(
      'samplingReportListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getSamplingReportsUseCaseProvider.overrideWithValue(
              GetSamplingReportsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(samplingReportListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getSamplingReports should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetList(
          (poolId) async => Left<Failure, List<SamplingReport>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getSamplingReports('pool-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('SamplingReportDetailNotifier', () {
    late SamplingReportDetailNotifier notifier;

    setUp(() {
      notifier = SamplingReportDetailNotifier(
        GetSamplingReportUsecase(fakeRepository),
      );
    });

    test('getSamplingReport should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, SamplingReportDetail>(_makeDetail()),
      );

      // Act
      await notifier.getSamplingReport('sampling-1');

      // Assert
      expect(notifier.state, isA<AsyncData<SamplingReportDetail?>>());
      final detail = (notifier.state as AsyncData<SamplingReportDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'sampling-1');
      expect(detail.quantity, 50);
      expect(detail.averageWeight, '150.5');
      expect(detail.poolName, 'Kolam A');
    });

    test(
      'samplingReportDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getSamplingReportUseCaseProvider.overrideWithValue(
              GetSamplingReportUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(samplingReportDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getSamplingReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGet(
          (id) async => Left<Failure, SamplingReportDetail>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getSamplingReport('sampling-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('SamplingReportMutationNotifier', () {
    late SamplingReportListNotifier listNotifier;
    late SamplingReportDetailNotifier detailNotifier;
    late SamplingReportMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = SamplingReportListNotifier(
        GetSamplingReportsUsecase(fakeRepository),
      );
      detailNotifier = SamplingReportDetailNotifier(
        GetSamplingReportUsecase(fakeRepository),
      );
      mutationNotifier = SamplingReportMutationNotifier(
        CreateSamplingReportUsecase(fakeRepository),
        UpdateSamplingReportUsecase(fakeRepository),
        DeleteSamplingReportUsecase(fakeRepository),
        listNotifier,
        detailNotifier,
      );
    });

    test('createSamplingReport should return data on success', () async {
      // Arrange
      fakeRepository.setupCreate(
        (cycleId, reportDate, quantity, averageWeight, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'sampling-new'}),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<SamplingReport>>([]),
      );

      // Act
      await mutationNotifier.createSamplingReport(
        'pool-1',
        'cycle-1',
        '2024-03-10',
        50,
        150.5,
        XFile('image.jpg'),
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createSamplingReport should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupCreate(
        (cycleId, reportDate, quantity, averageWeight, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'sampling-new'}),
      );
      fakeRepository.setupGetList((poolId) async {
        listRefreshed = true;
        return Right<Failure, List<SamplingReport>>([_makeReport()]);
      });

      // Act
      await mutationNotifier.createSamplingReport(
        'pool-1',
        'cycle-1',
        '2024-03-10',
        50,
        150.5,
        XFile('image.jpg'),
      );

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'createSamplingReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupCreate(
          (cycleId, reportDate, quantity, averageWeight, image) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.createSamplingReport(
          'pool-1',
          'cycle-1',
          '2024-03-10',
          50,
          150.5,
          XFile('image.jpg'),
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('updateSamplingReport should return data on success', () async {
      // Arrange
      fakeRepository.setupUpdate(
        (id, reportDate, quantity, averageWeight, image) async =>
            Right<Failure, Map<String, dynamic>>({
              'id': 'sampling-1',
              'reportDate': '2024-03-15',
            }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<SamplingReport>>([]),
      );
      fakeRepository.setupGet(
        (id) async => Right<Failure, SamplingReportDetail>(_makeDetail()),
      );

      // Act
      await mutationNotifier.updateSamplingReport(
        'sampling-1',
        'pool-1',
        '2024-03-15',
        55,
        160.0,
        null,
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test(
      'updateSamplingReport should refresh list and detail after success',
      () async {
        // Arrange
        var listRefreshed = false;
        var detailRefreshed = false;
        fakeRepository.setupUpdate(
          (id, reportDate, quantity, averageWeight, image) async =>
              Right<Failure, Map<String, dynamic>>({'id': 'sampling-1'}),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<SamplingReport>>([_makeReport()]);
        });
        fakeRepository.setupGet((id) async {
          detailRefreshed = true;
          return Right<Failure, SamplingReportDetail>(_makeDetail());
        });

        // Act
        await mutationNotifier.updateSamplingReport(
          'sampling-1',
          'pool-1',
          '2024-03-15',
          55,
          160.0,
          null,
        );

        // Assert
        expect(listRefreshed, true);
        expect(detailRefreshed, true);
      },
    );

    test(
      'updateSamplingReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupUpdate(
          (id, reportDate, quantity, averageWeight, image) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.updateSamplingReport(
          'sampling-1',
          'pool-1',
          '2024-03-15',
          55,
          160.0,
          null,
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('deleteSamplingReport should return data on success', () async {
      // Arrange
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Laporan sampling berhasil dihapus',
        }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<SamplingReport>>([]),
      );

      // Act
      await mutationNotifier.deleteSamplingReport('sampling-1', 'pool-1');

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('deleteSamplingReport should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Laporan sampling berhasil dihapus',
        }),
      );
      fakeRepository.setupGetList((poolId) async {
        listRefreshed = true;
        return Right<Failure, List<SamplingReport>>([]);
      });

      // Act
      await mutationNotifier.deleteSamplingReport('sampling-1', 'pool-1');

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'deleteSamplingReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupDelete(
          (id) async => Left<Failure, Map<String, dynamic>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await mutationNotifier.deleteSamplingReport('sampling-1', 'pool-1');

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
