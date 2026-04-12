import 'package:budidaya_lele_mobile/features/vitamin-report/data/datasources/vitamin_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/data/repositories/vitamin_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report_detail.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/repositories/vitamin_report_repository.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/create_vitamin_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/delete_vitamin_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/get_vitamin_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/get_vitamin_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/usecases/update_vitamin_report_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final vitaminReportDatasourceProvider = Provider(
  (ref) => VitaminReportDatasource(),
);

// Provider Repository
final vitaminReportRepositoryProvider = Provider<VitaminReportRepository>((
  ref,
) {
  final datasource = ref.read(vitaminReportDatasourceProvider);
  return VitaminReportRepositoryImpl(datasource);
});

// Provider Usecase
final getVitaminReportsUseCaseProvider = Provider<GetVitaminReportsUsecase>((
  ref,
) {
  final repository = ref.read(vitaminReportRepositoryProvider);
  return GetVitaminReportsUsecase(repository);
});

final getVitaminReportUseCaseProvider = Provider<GetVitaminReportUsecase>((
  ref,
) {
  final repository = ref.read(vitaminReportRepositoryProvider);
  return GetVitaminReportUsecase(repository);
});

final createVitaminReportUseCaseProvider = Provider<CreateVitaminReportUsecase>(
  (ref) {
    final repository = ref.read(vitaminReportRepositoryProvider);
    return CreateVitaminReportUsecase(repository);
  },
);

final updateVitaminReportUseCaseProvider = Provider<UpdateVitaminReportUsecase>(
  (ref) {
    final repository = ref.read(vitaminReportRepositoryProvider);
    return UpdateVitaminReportUsecase(repository);
  },
);

final deleteVitaminReportUseCaseProvider = Provider<DeleteVitaminReportUsecase>(
  (ref) {
    final repository = ref.read(vitaminReportRepositoryProvider);
    return DeleteVitaminReportUsecase(repository);
  },
);

class VitaminReportListNotifier
    extends StateNotifier<AsyncValue<List<VitaminReport>>> {
  final GetVitaminReportsUsecase _getVitaminReportsUsecase;

  VitaminReportListNotifier(this._getVitaminReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getVitaminReports(String poolId) async {
    state = const AsyncValue.loading();
    final result = await _getVitaminReportsUsecase.execute(poolId);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (vitaminReports) {
        state = AsyncValue.data(vitaminReports);
      },
    );
  }
}

class VitaminReportDetailNotifier
    extends StateNotifier<AsyncValue<VitaminReportDetail?>> {
  final GetVitaminReportUsecase _getVitaminReportUsecase;

  VitaminReportDetailNotifier(this._getVitaminReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getVitaminReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getVitaminReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (vitaminReport) {
        state = AsyncValue.data(vitaminReport);
      },
    );
  }
}

class VitaminReportMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateVitaminReportUsecase _createVitaminReportUsecase;
  final UpdateVitaminReportUsecase _updateVitaminReportUsecase;
  final DeleteVitaminReportUsecase _deleteVitaminReportUsecase;
  final VitaminReportListNotifier _listNotifier;
  final VitaminReportDetailNotifier _detailNotifier;

  VitaminReportMutationNotifier(
    this._createVitaminReportUsecase,
    this._updateVitaminReportUsecase,
    this._deleteVitaminReportUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  Future<void> createVitaminReport(
    String poolId,
    String cycleId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createVitaminReportUsecase.execute(
      cycleId,
      inventoryId,
      reportDate,
      quantity,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan vitamin',
          StackTrace.current,
        );
      },
      (vitaminReport) {
        state = AsyncValue.data(null);
        _listNotifier.getVitaminReports(poolId);
      },
    );
  }

  // Update vitamin report
  Future<void> updateVitaminReport(
    String id,
    String poolId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile? image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updateVitaminReportUsecase.execute(
      id,
      inventoryId,
      reportDate,
      quantity,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah laporan vitamin',
          StackTrace.current,
        );
      },
      (vitaminReport) {
        state = AsyncValue.data(null);
        _listNotifier.getVitaminReports(poolId);
        _detailNotifier.getVitaminReport(id);
      },
    );
  }

  // Delete vitamin report
  Future<void> deleteVitaminReport(String id, String poolId) async {
    state = const AsyncValue.loading();
    final result = await _deleteVitaminReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus laporan vitamin',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getVitaminReports(poolId);
      },
    );
  }
}

// provider Utama
// Vitamin Report List Notifier Provider
final vitaminReportListNotifierProvider =
    StateNotifierProvider<
      VitaminReportListNotifier,
      AsyncValue<List<VitaminReport>>
    >((ref) {
      final getVitaminReportsUsecase = ref.read(
        getVitaminReportsUseCaseProvider,
      );

      return VitaminReportListNotifier(getVitaminReportsUsecase);
    });

// Vitamin Report Detail Notifier Provider
final vitaminReportDetailNotifierProvider =
    StateNotifierProvider<
      VitaminReportDetailNotifier,
      AsyncValue<VitaminReportDetail?>
    >((ref) {
      final getVitaminReportUsecase = ref.read(getVitaminReportUseCaseProvider);
      return VitaminReportDetailNotifier(getVitaminReportUsecase);
    });

// Vitamin Report Mutation Notifier Provider
final vitaminReportMutationNotifierProvider =
    StateNotifierProvider<VitaminReportMutationNotifier, AsyncValue<void>>((
      ref,
    ) {
      final createVitaminReportUsecase = ref.read(
        createVitaminReportUseCaseProvider,
      );
      final updateVitaminReportUsecase = ref.read(
        updateVitaminReportUseCaseProvider,
      );
      final deleteVitaminReportUsecase = ref.read(
        deleteVitaminReportUseCaseProvider,
      );
      final listNotifier = ref.read(vitaminReportListNotifierProvider.notifier);
      final detailNotifier = ref.read(
        vitaminReportDetailNotifierProvider.notifier,
      );

      return VitaminReportMutationNotifier(
        createVitaminReportUsecase,
        updateVitaminReportUsecase,
        deleteVitaminReportUsecase,
        listNotifier,
        detailNotifier,
      );
    });
