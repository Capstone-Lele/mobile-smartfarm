import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report_detail.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/repositories/sick_report_repository.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/usecases/create_sick_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/usecases/delete_sick_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/usecases/get_sick_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/usecases/get_sick_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/sick-report/presentation/providers/sick_report_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeSickReportRepository implements SickReportRepository {
  Future<Either<Failure, List<SickReport>>> Function(String)? _getListCallback;
  Future<Either<Failure, SickReportDetail>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    String,
    String,
    int,
    XFile,
  )?
  _createCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String)?
  _deleteCallback;

  void setupGetList(
    Future<Either<Failure, List<SickReport>>> Function(String) callback,
  ) => _getListCallback = callback;

  void setupGet(
    Future<Either<Failure, SickReportDetail>> Function(String) callback,
  ) => _getCallback = callback;

  void setupCreate(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      String,
      String,
      int,
      XFile,
    )
    callback,
  ) => _createCallback = callback;

  void setupDelete(
    Future<Either<Failure, Map<String, dynamic>>> Function(String) callback,
  ) => _deleteCallback = callback;

  @override
  Future<Either<Failure, List<SickReport>>> getSickReports(String poolId) {
    if (_getListCallback != null) return _getListCallback!(poolId);
    return Future.value(Right<Failure, List<SickReport>>([]));
  }

  @override
  Future<Either<Failure, SickReportDetail>> getSickReport(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSickReport(
    String poolId,
    String originCycleId,
    String destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
  ) {
    if (_createCallback != null) {
      return _createCallback!(
        poolId,
        originCycleId,
        destinationCycleId,
        reportDate,
        quantity,
        image,
      );
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteSickReport(String id) {
    if (_deleteCallback != null) return _deleteCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

SickReport _makeReport({String id = 'sick-1'}) => SickReport(
  originPoolName: 'Kolam A',
  originCategory: 'breeding',
  destinationPoolName: 'Kolam Karantina',
  destinationCategory: 'quarantine',
  user: 'John Doe',
  id: id,
  originCycleId: 'cycle-1',
  destinationCycleId: 'cycle-2',
  userId: 'user-1',
  reportDate: '2024-06-01',
  quantity: 15,
  image: 'https://example.com/image.jpg',
  type: 'Sakit',
  createdAt: '2024-06-01T00:00:00.000Z',
  updatedAt: '2024-06-01T00:00:00.000Z',
  deletedAt: null,
);

SickReportDetail _makeDetail({String id = 'sick-1'}) => SickReportDetail(
  originPoolName: 'Kolam A',
  originCategory: 'breeding',
  destinationPoolName: 'Kolam Karantina',
  destinationCategory: 'quarantine',
  user: 'John Doe',
  startDate: '2024-06-01',
  id: id,
  originCycleId: 'cycle-1',
  destinationCycleId: 'cycle-2',
  userId: 'user-1',
  reportDate: '2024-06-01',
  quantity: 15,
  image: 'https://example.com/image.jpg',
  type: 'Sakit',
  createdAt: '2024-06-01T00:00:00.000Z',
  updatedAt: '2024-06-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeSickReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeSickReportRepository();
  });

  group('SickReportListNotifier', () {
    late SickReportListNotifier notifier;

    setUp(() {
      notifier = SickReportListNotifier(
        GetSickReportsUsecase(fakeRepository),
      );
    });

    test('getSickReports should return data on success', () async {
      // Arrange
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<SickReport>>([_makeReport()]),
      );

      // Act
      await notifier.getSickReports('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<List<SickReport>>>());
      final data = (notifier.state as AsyncData<List<SickReport>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'sick-1');
      expect(data.first.quantity, 15);
      expect(data.first.originPoolName, 'Kolam A');
    });

    test(
      'sickReportListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getSickReportsUseCaseProvider.overrideWithValue(
              GetSickReportsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(sickReportListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getSickReports should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetList(
          (poolId) async => Left<Failure, List<SickReport>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getSickReports('pool-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('SickReportDetailNotifier', () {
    late SickReportDetailNotifier notifier;

    setUp(() {
      notifier = SickReportDetailNotifier(
        GetSickReportUsecase(fakeRepository),
      );
    });

    test('getSickReport should return detail on success', () async {
      // Arrange
      fakeRepository.setupGet(
        (id) async => Right<Failure, SickReportDetail>(_makeDetail()),
      );

      // Act
      await notifier.getSickReport('sick-1');

      // Assert
      expect(notifier.state, isA<AsyncData<SickReportDetail?>>());
      final detail = (notifier.state as AsyncData<SickReportDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'sick-1');
      expect(detail.quantity, 15);
      expect(detail.originPoolName, 'Kolam A');
      expect(detail.destinationPoolName, 'Kolam Karantina');
    });

    test(
      'sickReportDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getSickReportUseCaseProvider.overrideWithValue(
              GetSickReportUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(sickReportDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getSickReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGet(
          (id) async => Left<Failure, SickReportDetail>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getSickReport('sick-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('SickReportMutationNotifier', () {
    late SickReportListNotifier listNotifier;
    late SickReportMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = SickReportListNotifier(
        GetSickReportsUsecase(fakeRepository),
      );
      mutationNotifier = SickReportMutationNotifier(
        CreateSickReportUsecase(fakeRepository),
        DeleteSickReportUsecase(fakeRepository),
        listNotifier,
      );
    });

    test('createSickReport should return data on success', () async {
      // Arrange
      fakeRepository.setupCreate(
        (poolId, originCycleId, destinationCycleId, reportDate, quantity, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'sick-new'}),
      );
      fakeRepository.setupGetList(
        (poolId) async => Right<Failure, List<SickReport>>([]),
      );

      // Act
      await mutationNotifier.createSickReport(
        'pool-1',
        'pool-2',
        'cycle-1',
        'cycle-2',
        '2024-06-01',
        15,
        XFile('image.jpg'),
      );

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createSickReport should refresh list after success', () async {
      // Arrange
      var listRefreshed = false;
      fakeRepository.setupCreate(
        (poolId, originCycleId, destinationCycleId, reportDate, quantity, image) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'sick-new'}),
      );
      fakeRepository.setupGetList((poolId) async {
        listRefreshed = true;
        return Right<Failure, List<SickReport>>([_makeReport()]);
      });

      // Act
      await mutationNotifier.createSickReport(
        'pool-1',
        'pool-2',
        'cycle-1',
        'cycle-2',
        '2024-06-01',
        15,
        XFile('image.jpg'),
      );

      // Assert
      expect(listRefreshed, true);
    });

    test(
      'createSickReport should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupCreate(
          (poolId, originCycleId, destinationCycleId, reportDate, quantity, image) async =>
              Left<Failure, Map<String, dynamic>>(
                FetchFailure('Network error'),
              ),
        );

        // Act
        await mutationNotifier.createSickReport(
          'pool-1',
          'pool-2',
          'cycle-1',
          'cycle-2',
          '2024-06-01',
          15,
          XFile('image.jpg'),
        );

        // Assert
        expect(mutationNotifier.state, isA<AsyncError>());
        final error = (mutationNotifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
