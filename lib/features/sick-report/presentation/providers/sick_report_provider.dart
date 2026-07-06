import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/sick-report/data/datasources/sick_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/sick-report/data/repositories/sick_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report_detail.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/repositories/sick_report_repository.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/usecases/create_sick_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/usecases/get_sick_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/usecases/get_sick_reports_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final sickReportDatasourceProvider = Provider((ref) => SickReportDatasource());

// Provider Repository
final sickReportRepositoryProvider = Provider<SickReportRepository>((ref) {
  final datasource = ref.read(sickReportDatasourceProvider);
  return SickReportRepositoryImpl(datasource);
});

// Provider Usecase
final getSickReportsUseCaseProvider = Provider<GetSickReportsUsecase>((ref) {
  final repository = ref.read(sickReportRepositoryProvider);
  return GetSickReportsUsecase(repository);
});

final getSickReportUseCaseProvider = Provider<GetSickReportUsecase>((ref) {
  final repository = ref.read(sickReportRepositoryProvider);
  return GetSickReportUsecase(repository);
});

final createSickReportUseCaseProvider = Provider<CreateSickReportUsecase>((
  ref,
) {
  final repository = ref.read(sickReportRepositoryProvider);
  return CreateSickReportUsecase(repository);
});

class SickReportListNotifier
    extends StateNotifier<AsyncValue<List<SickReport>>> {
  final GetSickReportsUsecase _getSickReportsUsecase;

  SickReportListNotifier(this._getSickReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getSickReports(String poolId) async {
    state = const AsyncValue.loading();
    final result = await _getSickReportsUsecase.execute(poolId);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (sickReports) {
        state = AsyncValue.data(sickReports);
      },
    );
  }
}

class SickReportDetailNotifier
    extends StateNotifier<AsyncValue<SickReportDetail?>> {
  final GetSickReportUsecase _getSickReportUsecase;

  SickReportDetailNotifier(this._getSickReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getSickReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getSickReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (sickReport) {
        state = AsyncValue.data(sickReport);
      },
    );
  }
}

class SickReportMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateSickReportUsecase _createSickReportUsecase;
  final SickReportListNotifier _listNotifier;
  final Ref _ref;

  SickReportMutationNotifier(
    this._createSickReportUsecase,
    this._listNotifier,
    this._ref,
  ) : super(const AsyncValue.data(null));

  // Create Sick Report
  Future<void> createSickReport(
    String poolId,
    String destinationPoolId,
    String originCycleId,
    String? destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
    String? endedAt,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createSickReportUsecase.execute(
      destinationPoolId,
      originCycleId,
      destinationCycleId,
      reportDate,
      quantity,
      image,
      endedAt,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan sakit',
          StackTrace.current,
        );
      },
      (sickReport) {
        state = AsyncValue.data(null);
        _listNotifier.getSickReports(poolId);
        // Refresh pool detail and list
        _ref.read(poolDetailNotifierProvider.notifier).getPool(poolId);
        _ref.read(poolListNotifierProvider.notifier).getPools();
      },
    );
  }
}

// provider Utama
// Sick Report List Notifier Provider
final sickReportListNotifierProvider =
    StateNotifierProvider<SickReportListNotifier, AsyncValue<List<SickReport>>>(
      (ref) {
        final getSickReportsUsecase = ref.read(getSickReportsUseCaseProvider);

        return SickReportListNotifier(getSickReportsUsecase);
      },
    );

// Sick Report Detail Notifier Provider
final sickReportDetailNotifierProvider =
    StateNotifierProvider<
      SickReportDetailNotifier,
      AsyncValue<SickReportDetail?>
    >((ref) {
      final getSickReportUsecase = ref.read(getSickReportUseCaseProvider);
      return SickReportDetailNotifier(getSickReportUsecase);
    });

// Sick Report Mutation Notifier Provider
final sickReportMutationNotifierProvider =
    StateNotifierProvider<SickReportMutationNotifier, AsyncValue<void>>((ref) {
      final createSickReportUsecase = ref.read(createSickReportUseCaseProvider);
      final listNotifier = ref.read(sickReportListNotifierProvider.notifier);

      return SickReportMutationNotifier(
        createSickReportUsecase,
        listNotifier,
        ref,
      );
    });
