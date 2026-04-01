import 'package:budidaya_lele_mobile/features/move-pool-report/data/datasources/move_pool_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/data/repositories/move_pool_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/entities/move_pool_report.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/repositories/move_pool_report_repository.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/usecases/create_move_pool_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/usecases/delete_move_pool_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/usecases/get_move_pool_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/usecases/get_move_pool_reports_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final movePoolReportDatasourceProvider = Provider(
  (ref) => MovePoolReportDatasource(),
);

// Provider Repository
final movePoolReportRepositoryProvider = Provider<MovePoolReportRepository>((
  ref,
) {
  final datasource = ref.read(movePoolReportDatasourceProvider);
  return MovePoolReportRepositoryImpl(datasource);
});

// Provider Usecase
final getMovePoolReportsUseCaseProvider = Provider<GetMovePoolReportsUsecase>((
  ref,
) {
  final repository = ref.read(movePoolReportRepositoryProvider);
  return GetMovePoolReportsUsecase(repository);
});

final getMovePoolReportUseCaseProvider = Provider<GetMovePoolReportUsecase>((
  ref,
) {
  final repository = ref.read(movePoolReportRepositoryProvider);
  return GetMovePoolReportUsecase(repository);
});

final createMovePoolReportUseCaseProvider =
    Provider<CreateMovePoolReportUsecase>((ref) {
      final repository = ref.read(movePoolReportRepositoryProvider);
      return CreateMovePoolReportUsecase(repository);
    });

final deleteMovePoolReportUseCaseProvider =
    Provider<DeleteMovePoolReportUsecase>((ref) {
      final repository = ref.read(movePoolReportRepositoryProvider);
      return DeleteMovePoolReportUsecase(repository);
    });

class MovePoolReportListNotifier
    extends StateNotifier<AsyncValue<List<MovePoolReport>>> {
  final GetMovePoolReportsUsecase _getMovePoolReportsUsecase;

  MovePoolReportListNotifier(this._getMovePoolReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getMovePoolReports(String poolId) async {
    state = const AsyncValue.loading();
    final result = await _getMovePoolReportsUsecase.execute(poolId);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (movePoolReports) {
        state = AsyncValue.data(movePoolReports);
      },
    );
  }
}

class MovePoolReportDetailNotifier
    extends StateNotifier<AsyncValue<MovePoolReport?>> {
  final GetMovePoolReportUsecase _getMovePoolReportUsecase;

  MovePoolReportDetailNotifier(this._getMovePoolReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getMovePoolReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getMovePoolReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (movePoolReport) {
        state = AsyncValue.data(movePoolReport);
      },
    );
  }
}

class MovePoolReportMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateMovePoolReportUsecase _createMovePoolReportUsecase;
  final DeleteMovePoolReportUsecase _deleteMovePoolReportUsecase;
  final MovePoolReportListNotifier _listNotifier;

  MovePoolReportMutationNotifier(
    this._createMovePoolReportUsecase,
    this._deleteMovePoolReportUsecase,
    this._listNotifier,
  ) : super(const AsyncValue.data(null));

  // Create Move Pool Report
  Future<void> createMovePoolReport(
    String poolId,
    String originCycleId,
    String destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createMovePoolReportUsecase.execute(
      originCycleId,
      destinationCycleId,
      reportDate,
      quantity,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan pindah kolam',
          StackTrace.current,
        );
      },
      (movePoolReport) {
        state = AsyncValue.data(null);
        _listNotifier.getMovePoolReports(poolId);
      },
    );
  }

  // Delete move pool report
  Future<void> deleteMovePoolReport(String id, String poolId) async {
    state = const AsyncValue.loading();
    final result = await _deleteMovePoolReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus laporan pindah kolam',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getMovePoolReports(poolId);
      },
    );
  }
}

// provider Utama
// Move Pool Report List Notifier Provider
final movePoolReportListNotifierProvider =
    StateNotifierProvider<
      MovePoolReportListNotifier,
      AsyncValue<List<MovePoolReport>>
    >((ref) {
      final getMovePoolReportsUsecase = ref.read(
        getMovePoolReportsUseCaseProvider,
      );

      return MovePoolReportListNotifier(getMovePoolReportsUsecase);
    });

// Move Pool Report Detail Notifier Provider
final movePoolReportDetailNotifierProvider =
    StateNotifierProvider<
      MovePoolReportDetailNotifier,
      AsyncValue<MovePoolReport?>
    >((ref) {
      final getMovePoolReportUsecase = ref.read(
        getMovePoolReportUseCaseProvider,
      );
      return MovePoolReportDetailNotifier(getMovePoolReportUsecase);
    });

// Move Pool Report Mutation Notifier Provider
final movePoolReportMutationNotifierProvider =
    StateNotifierProvider<MovePoolReportMutationNotifier, AsyncValue<void>>((
      ref,
    ) {
      final createMovePoolReportUsecase = ref.read(
        createMovePoolReportUseCaseProvider,
      );
      final deleteMovePoolReportUsecase = ref.read(
        deleteMovePoolReportUseCaseProvider,
      );
      final listNotifier = ref.read(
        movePoolReportListNotifierProvider.notifier,
      );

      return MovePoolReportMutationNotifier(
        createMovePoolReportUsecase,
        deleteMovePoolReportUsecase,
        listNotifier,
      );
    });
