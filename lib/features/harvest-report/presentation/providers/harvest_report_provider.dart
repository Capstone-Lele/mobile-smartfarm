// Provider Datasource
import 'package:budidaya_lele_mobile/features/harvest-report/data/datasources/harvest_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/data/repositories/harvest_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/repositories/harvest_report_repository.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/usecases/create_harvest_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/usecases/get_harvest_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/usecases/get_harvest_reports_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

final harvestReportDatasourceProvider = Provider(
  (ref) => HarvestReportDatasource(),
);

// Provider Repository
final harvestReportRepositoryProvider = Provider<HarvestReportRepository>((
  ref,
) {
  final datasource = ref.read(harvestReportDatasourceProvider);
  return HarvestReportRepositoryImpl(datasource);
});

// Provider Usecase
final getHarvestReportsUseCaseProvider = Provider<GetHarvestReportsUsecase>((
  ref,
) {
  final repository = ref.read(harvestReportRepositoryProvider);
  return GetHarvestReportsUsecase(repository);
});

final getHarvestReportUseCaseProvider = Provider<GetHarvestReportUsecase>((
  ref,
) {
  final repository = ref.read(harvestReportRepositoryProvider);
  return GetHarvestReportUsecase(repository);
});

final createHarvestReportUseCaseProvider = Provider<CreateHarvestReportUsecase>(
  (ref) {
    final repository = ref.read(harvestReportRepositoryProvider);
    return CreateHarvestReportUsecase(repository);
  },
);

class HarvestReportListNotifier
    extends StateNotifier<AsyncValue<List<HarvestReport>>> {
  final GetHarvestReportsUsecase _getHarvestReportsUsecase;

  HarvestReportListNotifier(this._getHarvestReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getHarvestReports() async {
    state = const AsyncValue.loading();
    final result = await _getHarvestReportsUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (harvestReports) {
        state = AsyncValue.data(harvestReports);
      },
    );
  }
}

class HarvestReportDetailNotifier
    extends StateNotifier<AsyncValue<HarvestReport?>> {
  final GetHarvestReportUsecase _getHarvestReportUsecase;

  HarvestReportDetailNotifier(this._getHarvestReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getHarvestReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getHarvestReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (harvestReport) {
        state = AsyncValue.data(harvestReport);
      },
    );
  }
}

class HarvestReportMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateHarvestReportUsecase _createHarvestReportUsecase;
  final HarvestReportListNotifier _listNotifier;

  HarvestReportMutationNotifier(
    this._createHarvestReportUsecase,
    this._listNotifier,
  ) : super(const AsyncValue.data(null));

  // Create Harvest Report
  Future<void> createHarvestReport(
    String cycleId,
    String reportDate,
    int amount,
    XFile image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createHarvestReportUsecase.execute(
      cycleId,
      reportDate,
      amount,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan panen',
          StackTrace.current,
        );
      },
      (harvestReport) {
        state = AsyncValue.data(null);
        _listNotifier.getHarvestReports();
      },
    );
  }
}

// provider Utama
// Harvest Report List Notifier Provider
final harvestReportListNotifierProvider =
    StateNotifierProvider<
      HarvestReportListNotifier,
      AsyncValue<List<HarvestReport>>
    >((ref) {
      final getHarvestReportsUsecase = ref.read(
        getHarvestReportsUseCaseProvider,
      );

      return HarvestReportListNotifier(getHarvestReportsUsecase);
    });

// Harvest Report Detail Notifier Provider
final harvestReportDetailNotifierProvider =
    StateNotifierProvider<
      HarvestReportDetailNotifier,
      AsyncValue<HarvestReport?>
    >((ref) {
      final getHarvestReportUsecase = ref.read(getHarvestReportUseCaseProvider);
      return HarvestReportDetailNotifier(getHarvestReportUsecase);
    });

// Harvest Report Mutation Notifier Provider
final harvestReportMutationNotifierProvider =
    StateNotifierProvider<HarvestReportMutationNotifier, AsyncValue<void>>((
      ref,
    ) {
      final createHarvestReportUsecase = ref.read(
        createHarvestReportUseCaseProvider,
      );
      final listNotifier = ref.read(harvestReportListNotifierProvider.notifier);

      return HarvestReportMutationNotifier(
        createHarvestReportUsecase,
        listNotifier,
      );
    });
