import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report_detail.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/repositories/vitamin_report_repository.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/create_vitamin_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/delete_vitamin_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/get_vitamin_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/get_vitamin_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/update_vitamin_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/presentation/providers/vitamin_report_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeVitaminReportRepository implements VitaminReportRepository {
  Future<Either<Failure, List<VitaminReport>>> Function(String)?
  _getListCallback;
  Future<Either<Failure, VitaminReportDetail>> Function(String)? _getCallback;
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
    Future<Either<Failure, List<VitaminReport>>> Function(String) callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, VitaminReportDetail>> Function(String) callback,
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
  Future<Either<Failure, List<VitaminReport>>> getVitaminReports(
    String poolId,
  ) {
    if (_getListCallback != null) return _getListCallback!(poolId);
    return Future.value(Right<Failure, List<VitaminReport>>([]));
  }

  @override
  Future<Either<Failure, VitaminReportDetail>> getVitaminReport(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createVitaminReport(
    String cycleId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  ) {
    if (_createCallback != null) {
      return _createCallback!(
        cycleId,
        inventoryId,
        reportDate,
        quantity,
        image,
      );
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateVitaminReport(
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
  Future<Either<Failure, Map<String, dynamic>>> deleteVitaminReport(String id) {
    if (_deleteCallback != null) return _deleteCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

VitaminReport _makeReport({String id = 'vitamin-1'}) => VitaminReport(
  poolId: 'pool-1',
  userId: 'user-1',
  user: 'John Doe',
  poolName: 'Kolam A',
  poolCategory: 'Lele',
  vitaminName: 'Vitamin C',
  unit: 'ml',
  id: id,
  cycleId: 'cycle-1',
  inventoryId: 'inventory-1',
  type: 'Vitamin',
  reportDate: '2024-05-05',
  quantity: '10',
  image: 'https://example.com/image.jpg',
  cycleCondition: 'Aktif',
  createdAt: '2024-05-05T00:00:00.000Z',
  updatedAt: '2024-05-05T00:00:00.000Z',
  deletedAt: null,
);

VitaminReportDetail _makeDetail({String id = 'vitamin-1'}) => VitaminReportDetail(
  userId: 'user-1',
  user: 'John Doe',
  vitaminName: 'Vitamin C',
  unit: 'ml',
  id: id,
  cycleId: 'cycle-1',
  inventoryId: 'inventory-1',
  type: 'Vitamin',
  reportDate: '2024-05-05',
  quantity: '10',
  image: 'https://example.com/image.jpg',
  cycleCondition: 'Aktif',
  createdAt: '2024-05-05T00:00:00.000Z',
  updatedAt: '2024-05-05T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeVitaminReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeVitaminReportRepository();
  });

  group('VitaminReportListNotifier', () {
    late VitaminReportListNotifier notifier;

    setUp(() {
      notifier = VitaminReportListNotifier(
        GetVitaminReportsUsecase(fakeRepository),
      );
    });

    test('getVitaminReports should return data on success', () async {
      // Arrange
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<VitaminReport>>([_makeReport()]),
      );

      // Act
      await notifier.getVitaminReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<List<VitaminReport>>>());
      final data = (notifier.state as AsyncData<List<VitaminReport>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'vitamin-1');
      expect(data.first.vitaminName, 'Vitamin C');
      expect(data.first.quantity, '10');
    });

    test(
      'vitaminReportListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getVitaminReportsUseCaseProvider.overrideWithValue(
              GetVitaminReportsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(vitaminReportListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getVitaminReports should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetList(
          (poolId) async => Left<Failure, List<VitaminReport>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getVitaminReports('pool-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('VitaminReportDetailNotifier', () {
    late VitaminReportDetailNotifier notifier;

    setUp(() {
      notifier = VitaminReportDetailNotifier(
        GetVitaminReportUsecase(fakeRepository),
      );
    });

    test('getVitaminReport should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, VitaminReportDetail>(_makeDetail()),
      );

      // Act
      await notifier.getVitaminReport('vitamin-1');

      // Assert
      expect(notifier.state, isA<AsyncData<VitaminReportDetail?>>());
      final detail = (notifier.state as AsyncData<VitaminReportDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'vitamin-1');
      expect(detail.vitaminName, 'Vitamin C');
      expect(detail.quantity, '10');
      expect(detail.unit, 'ml');
    });

    test(
      'vitaminReportDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getVitaminReportUseCaseProvider.overrideWithValue(
              GetVitaminReportUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(vitaminReportDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getVitaminReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGet(
          (id) async => Left<Failure, VitaminReportDetail>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getVitaminReport('vitamin-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('VitaminReportMutationNotifier', () {
    late VitaminReportListNotifier listNotifier;
    late VitaminReportDetailNotifier detailNotifier;
    late VitaminReportMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = VitaminReportListNotifier(
        GetVitaminReportsUsecase(fakeRepository),
      );
      detailNotifier = VitaminReportDetailNotifier(
        GetVitaminReportUsecase(fakeRepository),
      );
      mutationNotifier = VitaminReportMutationNotifier(
        CreateVitaminReportUsecase(fakeRepository),
        UpdateVitaminReportUsecase(fakeRepository),
        DeleteVitaminReportUsecase(fakeRepository),
        listNotifier,
        detailNotifier,
      );
    });

    test('createVitaminReport should return data on success', () async {
      // Arrange
      fakeRepository.setupCreate(
        (cycleId, inventoryId, reportDate, quantity, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'vitamin-new'}),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<VitaminReport>>([]),
      );

      // Act
      await mutationNotifier.createVitaminReport(
        'pool-1',
        'cycle-1',
        'inventory-1',
        '2024-05-05',
        10,
        XFile('image.jpg'),
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createVitaminReport should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupCreate(
        (cycleId, inventoryId, reportDate, quantity, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'vitamin-new'}),
      );
      fakeRepository.setupGetList((poolId) async {
        listRefreshed = true;
        return Right<Failure, List<VitaminReport>>([_makeReport()]);
      });

      // Act
      await mutationNotifier.createVitaminReport(
        'pool-1',
        'cycle-1',
        'inventory-1',
        '2024-05-05',
        10,
        XFile('image.jpg'),
      );

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'createVitaminReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupCreate(
          (cycleId, inventoryId, reportDate, quantity, image) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.createVitaminReport(
          'pool-1',
          'cycle-1',
          'inventory-1',
          '2024-05-05',
          10,
          XFile('image.jpg'),
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('updateVitaminReport should return data on success', () async {
      // Arrange
      fakeRepository.setupUpdate(
        (id, inventoryId, reportDate, quantity, image) async =>
            Right<Failure, Map<String, dynamic>>({
              'id': 'vitamin-1',
              'reportDate': '2024-05-10',
            }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<VitaminReport>>([]),
      );
      fakeRepository.setupGet(
        (id) async => Right<Failure, VitaminReportDetail>(_makeDetail()),
      );

      // Act
      await mutationNotifier.updateVitaminReport(
        'vitamin-1',
        'pool-1',
        'inventory-1',
        '2024-05-10',
        12,
        null,
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test(
      'updateVitaminReport should refresh list and detail after success',
      () async {
        // Arrange
        var listRefreshed = false;
        var detailRefreshed = false;
        fakeRepository.setupUpdate(
          (id, inventoryId, reportDate, quantity, image) async =>
              Right<Failure, Map<String, dynamic>>({'id': 'vitamin-1'}),
        );
        fakeRepository.setupGetList((poolId) async {
          listRefreshed = true;
          return Right<Failure, List<VitaminReport>>([_makeReport()]);
        });
        fakeRepository.setupGet((id) async {
          detailRefreshed = true;
          return Right<Failure, VitaminReportDetail>(_makeDetail());
        });

        // Act
        await mutationNotifier.updateVitaminReport(
          'vitamin-1',
          'pool-1',
          'inventory-1',
          '2024-05-10',
          12,
          null,
        );

        // Assert
        expect(listRefreshed, true);
        expect(detailRefreshed, true);
      },
    );

    test(
      'updateVitaminReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupUpdate(
          (id, inventoryId, reportDate, quantity, image) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.updateVitaminReport(
          'vitamin-1',
          'pool-1',
          'inventory-1',
          '2024-05-10',
          12,
          null,
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );

    test('deleteVitaminReport should return data on success', () async {
      // Arrange
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Laporan vitamin berhasil dihapus',
        }),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<VitaminReport>>([]),
      );

      // Act
      await mutationNotifier.deleteVitaminReport('vitamin-1', 'pool-1');

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('deleteVitaminReport should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({
          'message': 'Laporan vitamin berhasil dihapus',
        }),
      );
      fakeRepository.setupGetList((poolId) async {
        listRefreshed = true;
        return Right<Failure, List<VitaminReport>>([]);
      });

      // Act
      await mutationNotifier.deleteVitaminReport('vitamin-1', 'pool-1');

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'deleteVitaminReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupDelete(
          (id) async => Left<Failure, Map<String, dynamic>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await mutationNotifier.deleteVitaminReport('vitamin-1', 'pool-1');

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
