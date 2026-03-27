import 'package:budidaya_lele_mobile/features/pool-cleaning-report/data/datasources/pool_cleaning_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/data/repositories/pool_cleaning_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/repositories/pool_cleaning_report_repository.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/create_pool_cleaning_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/delete_pool_cleaning_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/get_pool_cleaning_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/get_pool_cleaning_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/usecases/update_pool_cleaning_report_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final poolCleaningReportDatasourceProvider = Provider(
  (ref) => PoolCleaningReportDatasource(),
);

// Provider Repository
final poolCleaningReportRepositoryProvider =
    Provider<PoolCleaningReportRepository>((ref) {
      final datasource = ref.read(poolCleaningReportDatasourceProvider);
      return PoolCleaningReportRepositoryImpl(datasource);
    });

// Provider Usecase
final getPoolCleaningReportsUseCaseProvider =
    Provider<GetPoolCleaningReportsUsecase>((ref) {
      final repository = ref.read(poolCleaningReportRepositoryProvider);
      return GetPoolCleaningReportsUsecase(repository);
    });

final getPoolCleaningReportUseCaseProvider =
    Provider<GetPoolCleaningReportUsecase>((ref) {
      final repository = ref.read(poolCleaningReportRepositoryProvider);
      return GetPoolCleaningReportUsecase(repository);
    });

final createPoolCleaningReportUseCaseProvider =
    Provider<CreatePoolCleaningReportUsecase>((ref) {
      final repository = ref.read(poolCleaningReportRepositoryProvider);
      return CreatePoolCleaningReportUsecase(repository);
    });

final updatePoolCleaningReportUseCaseProvider =
    Provider<UpdatePoolCleaningReportUsecase>((ref) {
      final repository = ref.read(poolCleaningReportRepositoryProvider);
      return UpdatePoolCleaningReportUsecase(repository);
    });

final deletePoolCleaningReportUseCaseProvider =
    Provider<DeletePoolCleaningReportUsecase>((ref) {
      final repository = ref.read(poolCleaningReportRepositoryProvider);
      return DeletePoolCleaningReportUsecase(repository);
    });

class PoolCleaningReportListNotifier
    extends StateNotifier<AsyncValue<List<PoolCleaningReport>>> {
  final GetPoolCleaningReportsUsecase _getPoolCleaningReportsUsecase;

  PoolCleaningReportListNotifier(this._getPoolCleaningReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getPoolCleaningReports(String poolId) async {
    state = const AsyncValue.loading();
    final result = await _getPoolCleaningReportsUsecase.execute(poolId);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (poolCleaningReports) {
        state = AsyncValue.data(poolCleaningReports);
      },
    );
  }
}

class PoolCleaningReportDetailNotifier
    extends StateNotifier<AsyncValue<PoolCleaningReport?>> {
  final GetPoolCleaningReportUsecase _getPoolCleaningReportUsecase;

  PoolCleaningReportDetailNotifier(this._getPoolCleaningReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getPoolCleaningReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getPoolCleaningReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (poolCleaningReport) {
        state = AsyncValue.data(poolCleaningReport);
      },
    );
  }
}

class PoolCleaningReportMutationNotifier
    extends StateNotifier<AsyncValue<void>> {
  final CreatePoolCleaningReportUsecase _createPoolCleaningReportUsecase;
  final UpdatePoolCleaningReportUsecase _updatePoolCleaningReportUsecase;
  final DeletePoolCleaningReportUsecase _deletePoolCleaningReportUsecase;
  final PoolCleaningReportListNotifier _listNotifier;
  final PoolCleaningReportDetailNotifier _detailNotifier;

  PoolCleaningReportMutationNotifier(
    this._createPoolCleaningReportUsecase,
    this._updatePoolCleaningReportUsecase,
    this._deletePoolCleaningReportUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Create Pool Cleaning Report
  Future<void> createPoolCleaningReport(
    String poolId,
    String reportDate,
    XFile image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createPoolCleaningReportUsecase.execute(
      poolId,
      reportDate,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan pembersihan kolam',
          StackTrace.current,
        );
      },
      (poolCleaningReport) {
        state = AsyncValue.data(null);
        _listNotifier.getPoolCleaningReports(poolId);
      },
    );
  }

  // Update pool cleaning report
  Future<void> updatePoolCleaningReport(
    String id,
    String poolId,
    String reportDate,
    XFile? image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updatePoolCleaningReportUsecase.execute(
      id,
      reportDate,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah laporan pembersihan kolam',
          StackTrace.current,
        );
      },
      (poolCleaningReport) {
        state = AsyncValue.data(null);
        _listNotifier.getPoolCleaningReports(poolId);
        _detailNotifier.getPoolCleaningReport(id);
      },
    );
  }

  // Delete pool cleaning report
  Future<void> deletePoolCleaningReport(String id, String poolId) async {
    state = const AsyncValue.loading();
    final result = await _deletePoolCleaningReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus laporan pembersihan kolam',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getPoolCleaningReports(poolId);
      },
    );
  }
}

// provider Utama
// Pool Cleaning Report List Notifier Provider
final poolCleaningReportListNotifierProvider =
    StateNotifierProvider<
      PoolCleaningReportListNotifier,
      AsyncValue<List<PoolCleaningReport>>
    >((ref) {
      final getPoolCleaningReportsUsecase = ref.read(
        getPoolCleaningReportsUseCaseProvider,
      );

      return PoolCleaningReportListNotifier(getPoolCleaningReportsUsecase);
    });

// Pool Cleaning Report Detail Notifier Provider
final poolCleaningReportDetailNotifierProvider =
    StateNotifierProvider<
      PoolCleaningReportDetailNotifier,
      AsyncValue<PoolCleaningReport?>
    >((ref) {
      final getPoolCleaningReportUsecase = ref.read(
        getPoolCleaningReportUseCaseProvider,
      );
      return PoolCleaningReportDetailNotifier(getPoolCleaningReportUsecase);
    });

// Pool Cleaning Report Mutation Notifier Provider
final poolCleaningReportMutationNotifierProvider =
    StateNotifierProvider<PoolCleaningReportMutationNotifier, AsyncValue<void>>(
      (ref) {
        final createPoolCleaningReportUsecase = ref.read(
          createPoolCleaningReportUseCaseProvider,
        );
        final updatePoolCleaningReportUsecase = ref.read(
          updatePoolCleaningReportUseCaseProvider,
        );
        final deletePoolCleaningReportUsecase = ref.read(
          deletePoolCleaningReportUseCaseProvider,
        );
        final listNotifier = ref.read(
          poolCleaningReportListNotifierProvider.notifier,
        );
        final detailNotifier = ref.read(
          poolCleaningReportDetailNotifierProvider.notifier,
        );

        return PoolCleaningReportMutationNotifier(
          createPoolCleaningReportUsecase,
          updatePoolCleaningReportUsecase,
          deletePoolCleaningReportUsecase,
          listNotifier,
          detailNotifier,
        );
      },
    );
