import 'package:budidaya_lele_mobile/features/report/data/datasources/report_datasource.dart';
import 'package:budidaya_lele_mobile/features/report/data/repositories/report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/activity_log.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/total_report.dart';
import 'package:budidaya_lele_mobile/features/report/domain/repositories/report_repository.dart';
import 'package:budidaya_lele_mobile/features/report/domain/usecases/get_activity_logs_usecase.dart';
import 'package:budidaya_lele_mobile/features/report/domain/usecases/get_total_reports_by_pool_usecase.dart';
import 'package:budidaya_lele_mobile/features/report/domain/usecases/get_total_reports_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final selectedMenuIndexProvider = StateProvider<int>((ref) => 0);

final selectedStatisticIndexProvider = StateProvider<int>((ref) => 0);

// Provider Datasource
final reportDatasourceProvider = Provider((ref) => ReportDatasource());

// Provider Repository
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final datasource = ref.read(reportDatasourceProvider);
  return ReportRepositoryImpl(datasource);
});

// Provider Usecase
final getActivityLogsUseCaseProvider = Provider<GetActivityLogsUsecase>((ref) {
  final repository = ref.read(reportRepositoryProvider);
  return GetActivityLogsUsecase(repository);
});

final getTotalReportsUseCaseProvider = Provider<GetTotalReportsUsecase>((ref) {
  final repository = ref.read(reportRepositoryProvider);
  return GetTotalReportsUsecase(repository);
});

final getTotalReportsByPoolUseCaseProvider =
    Provider<GetTotalReportsByPoolUsecase>((ref) {
      final repository = ref.read(reportRepositoryProvider);
      return GetTotalReportsByPoolUsecase(repository);
    });

class ActivityLogListNotifier
    extends StateNotifier<AsyncValue<List<ActivityLog>>> {
  final GetActivityLogsUsecase _getActivityLogsUsecase;

  ActivityLogListNotifier(this._getActivityLogsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getActivityLogs() async {
    state = const AsyncValue.loading();
    final result = await _getActivityLogsUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (activityLogs) {
        state = AsyncValue.data(activityLogs);
      },
    );
  }
}

class TotalReportsNotifier extends StateNotifier<AsyncValue<TotalReport?>> {
  final GetTotalReportsUsecase _getTotalReportsUsecase;

  TotalReportsNotifier(this._getTotalReportsUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getTotalReports(int month) async {
    state = const AsyncValue.loading();
    final result = await _getTotalReportsUsecase.execute(month);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (totalReport) {
        state = AsyncValue.data(totalReport);
      },
    );
  }
}

class TotalReportsByPoolNotifier
    extends StateNotifier<AsyncValue<TotalReport?>> {
  final GetTotalReportsByPoolUsecase _getTotalReportsByPoolUsecase;

  TotalReportsByPoolNotifier(this._getTotalReportsByPoolUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getTotalReportsByPool(String poolId, int month) async {
    state = const AsyncValue.loading();
    final result = await _getTotalReportsByPoolUsecase.execute(poolId, month);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (totalReport) {
        state = AsyncValue.data(totalReport);
      },
    );
  }
}

// provider Utama
// Activity Log List Notifier Provider
final activityLogListNotifierProvider =
    StateNotifierProvider<
      ActivityLogListNotifier,
      AsyncValue<List<ActivityLog>>
    >((ref) {
      final getActivityLogsUsecase = ref.read(getActivityLogsUseCaseProvider);

      return ActivityLogListNotifier(getActivityLogsUsecase);
    });

// Total Reports Notifier Provider
final totalReportsNotifierProvider =
    StateNotifierProvider<TotalReportsNotifier, AsyncValue<TotalReport?>>((
      ref,
    ) {
      final getTotalReportsUsecase = ref.read(getTotalReportsUseCaseProvider);
      return TotalReportsNotifier(getTotalReportsUsecase);
    });

// Total Reports By Pool Notifier Provider
final totalReportsByPoolNotifierProvider =
    StateNotifierProvider<TotalReportsByPoolNotifier, AsyncValue<TotalReport?>>((
      ref,
    ) {
      final getTotalReportsByPoolUsecase = ref.read(getTotalReportsByPoolUseCaseProvider);
      return TotalReportsByPoolNotifier(getTotalReportsByPoolUsecase);
    });
