import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/activity_log.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/total_report.dart';
import 'package:budidaya_lele_mobile/features/report/domain/repositories/report_repository.dart';
import 'package:budidaya_lele_mobile/features/report/domain/usecases/get_activity_logs_usecase.dart';
import 'package:budidaya_lele_mobile/features/report/domain/usecases/get_total_reports_by_pool_usecase.dart';
import 'package:budidaya_lele_mobile/features/report/domain/usecases/get_total_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeReportRepository implements ReportRepository {
  Future<Either<Failure, List<ActivityLog>>> Function()? _getActivityLogsCallback;
  Future<Either<Failure, TotalReport>> Function(int)? _getTotalReportsCallback;
  Future<Either<Failure, TotalReport>> Function(String, int)? _getTotalReportsByPoolCallback;

  void setupGetActivityLogs(
    Future<Either<Failure, List<ActivityLog>>> Function() callback,
  ) => _getActivityLogsCallback = callback;

  void setupGetTotalReports(
    Future<Either<Failure, TotalReport>> Function(int) callback,
  ) => _getTotalReportsCallback = callback;

  void setupGetTotalReportsByPool(
    Future<Either<Failure, TotalReport>> Function(String, int) callback,
  ) => _getTotalReportsByPoolCallback = callback;

  @override
  Future<Either<Failure, List<ActivityLog>>> getActivityLogs() {
    if (_getActivityLogsCallback != null) return _getActivityLogsCallback!();
    return Future.value(Right<Failure, List<ActivityLog>>([]));
  }

  @override
  Future<Either<Failure, TotalReport>> getTotalReports(int month) {
    if (_getTotalReportsCallback != null) return _getTotalReportsCallback!(month);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, TotalReport>> getTotalReportsByPool(String poolId, int month) {
    if (_getTotalReportsByPoolCallback != null) return _getTotalReportsByPoolCallback!(poolId, month);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

ActivityLog _makeActivityLog({String id = 'log-1'}) => ActivityLog(
  id: id,
  noteId: 'note-1',
  userId: 'user-1',
  userName: 'John Doe',
  poolName: 'Kolam A',
  activity: 'Pemberian pakan',
  createdAt: '2024-09-01T00:00:00.000Z',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
  notes: 'Pemberian pakan 2kg',
);

TotalReport _makeTotalReport() => TotalReport(
  totalFeedNotes: 10,
  totalVitaminNotes: 5,
  totalMovePoolNotes: 2,
  totalSickNotes: 3,
  totalSamplingNotes: 8,
  totalCleaningNotes: 6,
  totalHarvestNotes: 1,
  totalMortalityNotes: 4,
  totalSeedNotes: 7,
);

void main() {
  late FakeReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeReportRepository();
  });

  group('ActivityLogListNotifier', () {
    late ActivityLogListNotifier notifier;

    setUp(() {
      notifier = ActivityLogListNotifier(GetActivityLogsUsecase(fakeRepository));
    });

    test('getActivityLogs should return data on success', () async {
      // Arrange
      fakeRepository.setupGetActivityLogs(
        () async => Right<Failure, List<ActivityLog>>([_makeActivityLog()]),
      );

      // Act
      await notifier.getActivityLogs();

      // Assert
      expect(notifier.state, isA<AsyncData<List<ActivityLog>>>());
      final data = (notifier.state as AsyncData<List<ActivityLog>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'log-1');
      expect(data.first.activity, 'Pemberian pakan');
    });

    test('activityLogListNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getActivityLogsUseCaseProvider.overrideWithValue(
            GetActivityLogsUsecase(fakeRepository),
          ),
        ],
      );

      final state = container.read(activityLogListNotifierProvider);

      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getActivityLogs should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupGetActivityLogs(
        () async => Left<Failure, List<ActivityLog>>(FetchFailure('Network error')),
      );

      // Act
      await notifier.getActivityLogs();

      // Assert
      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('TotalReportsNotifier', () {
    late TotalReportsNotifier notifier;

    setUp(() {
      notifier = TotalReportsNotifier(GetTotalReportsUsecase(fakeRepository));
    });

    test('getTotalReports should return data on success', () async {
      // Arrange
      fakeRepository.setupGetTotalReports(
        (month) async => Right<Failure, TotalReport>(_makeTotalReport()),
      );

      // Act
      await notifier.getTotalReports(9);

      // Assert
      expect(notifier.state, isA<AsyncData<TotalReport?>>());
      final data = (notifier.state as AsyncData<TotalReport?>).value;
      expect(data, isNotNull);
      expect(data!.totalFeedNotes, 10);
      expect(data.totalHarvestNotes, 1);
    });

    test('totalReportsNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getTotalReportsUseCaseProvider.overrideWithValue(
            GetTotalReportsUsecase(fakeRepository),
          ),
        ],
      );

      final state = container.read(totalReportsNotifierProvider);

      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getTotalReports should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupGetTotalReports(
        (month) async => Left<Failure, TotalReport>(FetchFailure('Network error')),
      );

      // Act
      await notifier.getTotalReports(9);

      // Assert
      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('TotalReportsByPoolNotifier', () {
    late TotalReportsByPoolNotifier notifier;

    setUp(() {
      notifier = TotalReportsByPoolNotifier(
        GetTotalReportsByPoolUsecase(fakeRepository),
      );
    });

    test('getTotalReportsByPool should return data on success', () async {
      // Arrange
      fakeRepository.setupGetTotalReportsByPool(
        (poolId, month) async => Right<Failure, TotalReport>(_makeTotalReport()),
      );

      // Act
      await notifier.getTotalReportsByPool('pool-1', 9);

      // Assert
      expect(notifier.state, isA<AsyncData<TotalReport?>>());
      final data = (notifier.state as AsyncData<TotalReport?>).value;
      expect(data, isNotNull);
      expect(data!.totalSamplingNotes, 8);
      expect(data.totalCleaningNotes, 6);
    });

    test('totalReportsByPoolNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getTotalReportsByPoolUseCaseProvider.overrideWithValue(
            GetTotalReportsByPoolUsecase(fakeRepository),
          ),
        ],
      );

      final state = container.read(totalReportsByPoolNotifierProvider);

      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getTotalReportsByPool should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupGetTotalReportsByPool(
        (poolId, month) async => Left<Failure, TotalReport>(FetchFailure('Network error')),
      );

      // Act
      await notifier.getTotalReportsByPool('pool-1', 9);

      // Assert
      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
