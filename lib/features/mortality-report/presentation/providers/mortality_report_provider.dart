import 'package:budidaya_lele_mobile/features/mortality-report/data/datasources/mortality_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/data/repositories/mortality_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/repositories/mortality_report_repository.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/usecases/create_mortality_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/usecases/delete_mortality_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/usecases/get_mortality_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/usecases/get_mortality_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/usecases/update_mortality_report_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final mortalityReportDatasourceProvider = Provider(
  (ref) => MortalityReportDatasource(),
);

// Provider Repository
final mortalityReportRepositoryProvider = Provider<MortalityReportRepository>((
  ref,
) {
  final datasource = ref.read(mortalityReportDatasourceProvider);
  return MortalityReportRepositoryImpl(datasource);
});

// Provider Usecase
final getMortalityReportsUseCaseProvider = Provider<GetMortalityReportsUsecase>(
  (ref) {
    final repository = ref.read(mortalityReportRepositoryProvider);
    return GetMortalityReportsUsecase(repository);
  },
);

final getMortalityReportUseCaseProvider = Provider<GetMortalityReportUsecase>((
  ref,
) {
  final repository = ref.read(mortalityReportRepositoryProvider);
  return GetMortalityReportUsecase(repository);
});

final createMortalityReportUseCaseProvider =
    Provider<CreateMortalityReportUsecase>((ref) {
      final repository = ref.read(mortalityReportRepositoryProvider);
      return CreateMortalityReportUsecase(repository);
    });

final updateMortalityReportUseCaseProvider =
    Provider<UpdateMortalityReportUsecase>((ref) {
      final repository = ref.read(mortalityReportRepositoryProvider);
      return UpdateMortalityReportUsecase(repository);
    });

final deleteMortalityReportUseCaseProvider =
    Provider<DeleteMortalityReportUsecase>((ref) {
      final repository = ref.read(mortalityReportRepositoryProvider);
      return DeleteMortalityReportUsecase(repository);
    });

class MortalityReportListNotifier
    extends StateNotifier<AsyncValue<List<MortalityReport>>> {
  final GetMortalityReportsUsecase _getMortalityReportsUsecase;

  MortalityReportListNotifier(this._getMortalityReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getMortalityReports() async {
    state = const AsyncValue.loading();
    final result = await _getMortalityReportsUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (mortalityReports) {
        state = AsyncValue.data(mortalityReports);
      },
    );
  }
}

class MortalityReportDetailNotifier
    extends StateNotifier<AsyncValue<MortalityReport?>> {
  final GetMortalityReportUsecase _getMortalityReportUsecase;

  MortalityReportDetailNotifier(this._getMortalityReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getMortalityReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getMortalityReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (mortalityReport) {
        state = AsyncValue.data(mortalityReport);
      },
    );
  }
}

class MortalityReportMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateMortalityReportUsecase _createMortalityReportUsecase;
  final UpdateMortalityReportUsecase _updateMortalityReportUsecase;
  final DeleteMortalityReportUsecase _deleteMortalityReportUsecase;
  final MortalityReportListNotifier _listNotifier;
  final MortalityReportDetailNotifier _detailNotifier;

  MortalityReportMutationNotifier(
    this._createMortalityReportUsecase,
    this._updateMortalityReportUsecase,
    this._deleteMortalityReportUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Create Mortality Report
  Future<void> createMortalityReport(
    String cycleId,
    String userId,
    String reportDate,
    int quantity,
    XFile image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createMortalityReportUsecase.execute(
      cycleId,
      userId,
      reportDate,
      quantity,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan kematian',
          StackTrace.current,
        );
      },
      (mortalityReport) {
        state = AsyncValue.data(null);
        _listNotifier.getMortalityReports();
      },
    );
  }

  // Update mortality report
  Future<void> updateMortalityReport(
    String id,
    String reportDate,
    int quantity,
    XFile? image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updateMortalityReportUsecase.execute(
      id,
      reportDate,
      quantity,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah laporan kematian',
          StackTrace.current,
        );
      },
      (mortalityReport) {
        state = AsyncValue.data(null);
        _listNotifier.getMortalityReports();
        _detailNotifier.getMortalityReport(id);
      },
    );
  }

  // Delete mortality report
  Future<void> deleteMortalityReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteMortalityReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus laporan kematian',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getMortalityReports();
      },
    );
  }
}

// provider Utama
// Mortality Report List Notifier Provider
final mortalityReportListNotifierProvider =
    StateNotifierProvider<
      MortalityReportListNotifier,
      AsyncValue<List<MortalityReport>>
    >((ref) {
      final getMortalityReportsUsecase = ref.read(
        getMortalityReportsUseCaseProvider,
      );

      return MortalityReportListNotifier(getMortalityReportsUsecase);
    });

// Mortality Report Detail Notifier Provider
final mortalityReportDetailNotifierProvider =
    StateNotifierProvider<
      MortalityReportDetailNotifier,
      AsyncValue<MortalityReport?>
    >((ref) {
      final getMortalityReportUsecase = ref.read(
        getMortalityReportUseCaseProvider,
      );
      return MortalityReportDetailNotifier(getMortalityReportUsecase);
    });

// Mortality Report Mutation Notifier Provider
final mortalityReportMutationNotifierProvider =
    StateNotifierProvider<MortalityReportMutationNotifier, AsyncValue<void>>((
      ref,
    ) {
      final createMortalityReportUsecase = ref.read(
        createMortalityReportUseCaseProvider,
      );
      final updateMortalityReportUsecase = ref.read(
        updateMortalityReportUseCaseProvider,
      );
      final deleteMortalityReportUsecase = ref.read(
        deleteMortalityReportUseCaseProvider,
      );
      final listNotifier = ref.read(
        mortalityReportListNotifierProvider.notifier,
      );
      final detailNotifier = ref.read(
        mortalityReportDetailNotifierProvider.notifier,
      );

      return MortalityReportMutationNotifier(
        createMortalityReportUsecase,
        updateMortalityReportUsecase,
        deleteMortalityReportUsecase,
        listNotifier,
        detailNotifier,
      );
    });
