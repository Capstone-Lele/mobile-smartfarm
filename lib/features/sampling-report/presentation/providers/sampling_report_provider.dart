import 'package:budidaya_lele_mobile/features/sampling-report/data/datasources/sampling_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/data/repositories/sampling_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report_detail.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/repositories/sampling_report_repository.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/create_sampling_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/delete_sampling_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/get_sampling_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/get_sampling_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/usecases/update_sampling_report_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final samplingReportDatasourceProvider = Provider(
  (ref) => SamplingReportDatasource(),
);

// Provider Repository
final samplingReportRepositoryProvider = Provider<SamplingReportRepository>((
  ref,
) {
  final datasource = ref.read(samplingReportDatasourceProvider);
  return SamplingReportRepositoryImpl(datasource);
});

// Provider Usecase
final getSamplingReportsUseCaseProvider = Provider<GetSamplingReportsUsecase>((
  ref,
) {
  final repository = ref.read(samplingReportRepositoryProvider);
  return GetSamplingReportsUsecase(repository);
});

final getSamplingReportUseCaseProvider = Provider<GetSamplingReportUsecase>((
  ref,
) {
  final repository = ref.read(samplingReportRepositoryProvider);
  return GetSamplingReportUsecase(repository);
});

final createSamplingReportUseCaseProvider =
    Provider<CreateSamplingReportUsecase>((ref) {
      final repository = ref.read(samplingReportRepositoryProvider);
      return CreateSamplingReportUsecase(repository);
    });

final updateSamplingReportUseCaseProvider =
    Provider<UpdateSamplingReportUsecase>((ref) {
      final repository = ref.read(samplingReportRepositoryProvider);
      return UpdateSamplingReportUsecase(repository);
    });

final deleteSamplingReportUseCaseProvider =
    Provider<DeleteSamplingReportUsecase>((ref) {
      final repository = ref.read(samplingReportRepositoryProvider);
      return DeleteSamplingReportUsecase(repository);
    });

class SamplingReportListNotifier
    extends StateNotifier<AsyncValue<List<SamplingReport>>> {
  final GetSamplingReportsUsecase _getSamplingReportsUsecase;

  SamplingReportListNotifier(this._getSamplingReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getSamplingReports(String poolId) async {
    state = const AsyncValue.loading();
    final result = await _getSamplingReportsUsecase.execute(poolId);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (samplingReports) {
        state = AsyncValue.data(samplingReports);
      },
    );
  }
}

class SamplingReportDetailNotifier
    extends StateNotifier<AsyncValue<SamplingReportDetail?>> {
  final GetSamplingReportUsecase _getSamplingReportUsecase;

  SamplingReportDetailNotifier(this._getSamplingReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getSamplingReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getSamplingReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (samplingReport) {
        state = AsyncValue.data(samplingReport);
      },
    );
  }
}

class SamplingReportMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateSamplingReportUsecase _createSamplingReportUsecase;
  final UpdateSamplingReportUsecase _updateSamplingReportUsecase;
  final DeleteSamplingReportUsecase _deleteSamplingReportUsecase;
  final SamplingReportListNotifier _listNotifier;
  final SamplingReportDetailNotifier _detailNotifier;

  SamplingReportMutationNotifier(
    this._createSamplingReportUsecase,
    this._updateSamplingReportUsecase,
    this._deleteSamplingReportUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Create Sampling Report
  Future<void> createSamplingReport(
    String poolId,
    String cycleId,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createSamplingReportUsecase.execute(
      cycleId,
      reportDate,
      quantity,
      averageWeight,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan sampling',
          StackTrace.current,
        );
      },
      (samplingReport) {
        state = AsyncValue.data(null);
        _listNotifier.getSamplingReports(poolId);
      },
    );
  }

  // Update sampling report
  Future<void> updateSamplingReport(
    String id,
    String poolId,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile? image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updateSamplingReportUsecase.execute(
      id,
      reportDate,
      quantity,
      averageWeight,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah laporan sampling',
          StackTrace.current,
        );
      },
      (samplingReport) {
        state = AsyncValue.data(null);
        _listNotifier.getSamplingReports(poolId);
        _detailNotifier.getSamplingReport(id);
      },
    );
  }

  // Delete sampling report
  Future<void> deleteSamplingReport(String id, String poolId) async {
    state = const AsyncValue.loading();
    final result = await _deleteSamplingReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus laporan sampling',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getSamplingReports(poolId);
      },
    );
  }
}

// provider Utama
// Sampling Report List Notifier Provider
final samplingReportListNotifierProvider =
    StateNotifierProvider<
      SamplingReportListNotifier,
      AsyncValue<List<SamplingReport>>
    >((ref) {
      final getSamplingReportsUsecase = ref.read(
        getSamplingReportsUseCaseProvider,
      );

      return SamplingReportListNotifier(getSamplingReportsUsecase);
    });

// Sampling Report Detail Notifier Provider
final samplingReportDetailNotifierProvider =
    StateNotifierProvider<
      SamplingReportDetailNotifier,
      AsyncValue<SamplingReportDetail?>
    >((ref) {
      final getSamplingReportUsecase = ref.read(
        getSamplingReportUseCaseProvider,
      );
      return SamplingReportDetailNotifier(getSamplingReportUsecase);
    });

// Sampling Report Mutation Notifier Provider
final samplingReportMutationNotifierProvider =
    StateNotifierProvider<SamplingReportMutationNotifier, AsyncValue<void>>((
      ref,
    ) {
      final createSamplingReportUsecase = ref.read(
        createSamplingReportUseCaseProvider,
      );
      final updateSamplingReportUsecase = ref.read(
        updateSamplingReportUseCaseProvider,
      );
      final deleteSamplingReportUsecase = ref.read(
        deleteSamplingReportUseCaseProvider,
      );
      final listNotifier = ref.read(
        samplingReportListNotifierProvider.notifier,
      );
      final detailNotifier = ref.read(
        samplingReportDetailNotifierProvider.notifier,
      );

      return SamplingReportMutationNotifier(
        createSamplingReportUsecase,
        updateSamplingReportUsecase,
        deleteSamplingReportUsecase,
        listNotifier,
        detailNotifier,
      );
    });
