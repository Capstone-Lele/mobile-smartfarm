import 'package:budidaya_lele_mobile/features/seed-report/data/datasources/seed_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/seed-report/data/repositories/seed_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/repositories/seed_report_repository.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/usecases/create_seed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/usecases/delete_seed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/usecases/get_seed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/usecases/get_seed_reports_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final seedReportDatasourceProvider = Provider((ref) => SeedReportDatasource());

// Provider Repository
final seedReportRepositoryProvider = Provider<SeedReportRepository>((ref) {
  final datasource = ref.read(seedReportDatasourceProvider);
  return SeedReportRepositoryImpl(datasource);
});

// Provider Usecase
final getSeedReportsUseCaseProvider = Provider<GetSeedReportsUsecase>((ref) {
  final repository = ref.read(seedReportRepositoryProvider);
  return GetSeedReportsUsecase(repository);
});

final getSeedReportUseCaseProvider = Provider<GetSeedReportUsecase>((ref) {
  final repository = ref.read(seedReportRepositoryProvider);
  return GetSeedReportUsecase(repository);
});

final createSeedReportUseCaseProvider = Provider<CreateSeedReportUsecase>((
  ref,
) {
  final repository = ref.read(seedReportRepositoryProvider);
  return CreateSeedReportUsecase(repository);
});

final deleteSeedReportUseCaseProvider = Provider<DeleteSeedReportUsecase>((
  ref,
) {
  final repository = ref.read(seedReportRepositoryProvider);
  return DeleteSeedReportUsecase(repository);
});

class SeedReportListNotifier
    extends StateNotifier<AsyncValue<List<SeedReport>>> {
  final GetSeedReportsUsecase _getSeedReportsUsecase;

  SeedReportListNotifier(this._getSeedReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getSeedReports(String poolId) async {
    state = const AsyncValue.loading();
    final result = await _getSeedReportsUsecase.execute(poolId);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (seedReports) {
        state = AsyncValue.data(seedReports);
      },
    );
  }
}

class SeedReportDetailNotifier extends StateNotifier<AsyncValue<SeedReport?>> {
  final GetSeedReportUsecase _getSeedReportUsecase;

  SeedReportDetailNotifier(this._getSeedReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getSeedReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getSeedReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (seedReport) {
        state = AsyncValue.data(seedReport);
      },
    );
  }
}

class SeedReportMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateSeedReportUsecase _createSeedReportUsecase;
  final DeleteSeedReportUsecase _deleteSeedReportUsecase;
  final SeedReportListNotifier _listNotifier;

  SeedReportMutationNotifier(
    this._createSeedReportUsecase,
    this._deleteSeedReportUsecase,
    this._listNotifier,
  ) : super(const AsyncValue.data(null));

  // Create Seed Report
  Future<void> createSeedReport(
    String poolId,
    String userId,
    String reportDate,
    int initialQuantity,
    int currentQuantity,
    double initialAverageWeight,
    XFile image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createSeedReportUsecase.execute(
      poolId,
      userId,
      reportDate,
      initialQuantity,
      currentQuantity,
      initialAverageWeight,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan benih',
          StackTrace.current,
        );
      },
      (seedReport) {
        state = AsyncValue.data(null);
        _listNotifier.getSeedReports('');
      },
    );
  }

  // Delete seed report
  Future<void> deleteSeedReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteSeedReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus laporan benih',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getSeedReports('');
      },
    );
  }
}

// provider Utama
// Seed Report List Notifier Provider
final seedReportListNotifierProvider =
    StateNotifierProvider<SeedReportListNotifier, AsyncValue<List<SeedReport>>>(
      (ref) {
        final getSeedReportsUsecase = ref.read(getSeedReportsUseCaseProvider);

        return SeedReportListNotifier(getSeedReportsUsecase);
      },
    );

// Seed Report Detail Notifier Provider
final seedReportDetailNotifierProvider =
    StateNotifierProvider<SeedReportDetailNotifier, AsyncValue<SeedReport?>>((
      ref,
    ) {
      final getSeedReportUsecase = ref.read(getSeedReportUseCaseProvider);
      return SeedReportDetailNotifier(getSeedReportUsecase);
    });

// Seed Report Mutation Notifier Provider
final seedReportMutationNotifierProvider =
    StateNotifierProvider<SeedReportMutationNotifier, AsyncValue<void>>((ref) {
      final createSeedReportUsecase = ref.read(createSeedReportUseCaseProvider);
      final deleteSeedReportUsecase = ref.read(deleteSeedReportUseCaseProvider);
      final listNotifier = ref.read(seedReportListNotifierProvider.notifier);

      return SeedReportMutationNotifier(
        createSeedReportUsecase,
        deleteSeedReportUsecase,
        listNotifier,
      );
    });
