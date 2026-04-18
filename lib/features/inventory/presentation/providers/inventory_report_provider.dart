import 'package:budidaya_lele_mobile/features/inventory/data/datasources/inventory_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/repositories/inventory_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_report_repository.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-report/create_inventory_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-report/delete_inventory_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-report/get_inventory_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-report/get_inventory_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-report/update_inventory_report_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final inventoryReportDatasourceProvider = Provider(
  (ref) => InventoryReportDatasource(),
);

// Provider Repository
final inventoryReportRepositoryProvider = Provider<InventoryReportRepository>((
  ref,
) {
  final datasource = ref.read(inventoryReportDatasourceProvider);
  return InventoryReportRepositoryImpl(datasource);
});

// Provider Usecase
final getInventoryReportsUseCaseProvider = Provider<GetInventoryReportsUsecase>(
  (ref) {
    final repository = ref.read(inventoryReportRepositoryProvider);
    return GetInventoryReportsUsecase(repository);
  },
);

final getInventoryReportUseCaseProvider = Provider<GetInventoryReportUsecase>((
  ref,
) {
  final repository = ref.read(inventoryReportRepositoryProvider);
  return GetInventoryReportUsecase(repository);
});

final createInventoryReportUseCaseProvider =
    Provider<CreateInventoryReportUsecase>((ref) {
      final repository = ref.read(inventoryReportRepositoryProvider);
      return CreateInventoryReportUsecase(repository);
    });

final updateInventoryReportUseCaseProvider =
    Provider<UpdateInventoryReportUsecase>((ref) {
      final repository = ref.read(inventoryReportRepositoryProvider);
      return UpdateInventoryReportUsecase(repository);
    });

final deleteInventoryReportUseCaseProvider =
    Provider<DeleteInventoryReportUsecase>((ref) {
      final repository = ref.read(inventoryReportRepositoryProvider);
      return DeleteInventoryReportUsecase(repository);
    });

class InventoryReportListNotifier
    extends StateNotifier<AsyncValue<List<InventoryReport>>> {
  final GetInventoryReportsUsecase _getInventoryReportsUsecase;

  InventoryReportListNotifier(this._getInventoryReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getInventoryReports() async {
    state = const AsyncValue.loading();
    final result = await _getInventoryReportsUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (inventoryReports) {
        state = AsyncValue.data(inventoryReports);
      },
    );
  }
}

class InventoryReportDetailNotifier
    extends StateNotifier<AsyncValue<InventoryReportDetail?>> {
  final GetInventoryReportUsecase _getInventoryReportUsecase;

  InventoryReportDetailNotifier(this._getInventoryReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getInventoryReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getInventoryReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (inventoryReport) {
        state = AsyncValue.data(inventoryReport);
      },
    );
  }
}

class InventoryReportMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateInventoryReportUsecase _createInventoryReportUsecase;
  final UpdateInventoryReportUsecase _updateInventoryReportUsecase;
  final DeleteInventoryReportUsecase _deleteInventoryReportUsecase;
  final InventoryReportListNotifier _listNotifier;
  final InventoryReportDetailNotifier _detailNotifier;

  InventoryReportMutationNotifier(
    this._createInventoryReportUsecase,
    this._updateInventoryReportUsecase,
    this._deleteInventoryReportUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Create Inventory Report
  Future<void> createInventoryReport(
    String inventoryId,
    String reportDate,
    int quantity,
    String type,
    XFile image,
    String? notes,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createInventoryReportUsecase.execute(
      inventoryId,
      reportDate,
      quantity,
      type,
      image,
      notes,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan inventaris',
          StackTrace.current,
        );
      },
      (inventoryReport) {
        state = AsyncValue.data(null);
        _listNotifier.getInventoryReports();
      },
    );
  }

  // Update inventory report
  Future<void> updateInventoryReport(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    String type,
    XFile? image,
    String? notes,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updateInventoryReportUsecase.execute(
      id,
      inventoryId,
      reportDate,
      quantity,
      type,
      image,
      notes,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah laporan inventaris',
          StackTrace.current,
        );
      },
      (inventoryReport) {
        state = AsyncValue.data(null);
        _listNotifier.getInventoryReports();
        _detailNotifier.getInventoryReport(id);
      },
    );
  }

  // Delete inventory report
  Future<void> deleteInventoryReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteInventoryReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus laporan inventaris',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getInventoryReports();
      },
    );
  }
}

// provider Utama
// Inventory Report List Notifier Provider
final inventoryReportListNotifierProvider =
    StateNotifierProvider<
      InventoryReportListNotifier,
      AsyncValue<List<InventoryReport>>
    >((ref) {
      final getInventoryReportsUsecase = ref.read(
        getInventoryReportsUseCaseProvider,
      );

      return InventoryReportListNotifier(getInventoryReportsUsecase);
    });

// Inventory Report Detail Notifier Provider
final inventoryReportDetailNotifierProvider =
    StateNotifierProvider<
      InventoryReportDetailNotifier,
      AsyncValue<InventoryReportDetail?>
    >((ref) {
      final getInventoryReportUsecase = ref.read(
        getInventoryReportUseCaseProvider,
      );
      return InventoryReportDetailNotifier(getInventoryReportUsecase);
    });

// Inventory Report Mutation Notifier Provider
final inventoryReportMutationNotifierProvider =
    StateNotifierProvider<InventoryReportMutationNotifier, AsyncValue<void>>((
      ref,
    ) {
      final createInventoryReportUsecase = ref.read(
        createInventoryReportUseCaseProvider,
      );
      final updateInventoryReportUsecase = ref.read(
        updateInventoryReportUseCaseProvider,
      );
      final deleteInventoryReportUsecase = ref.read(
        deleteInventoryReportUseCaseProvider,
      );
      final listNotifier = ref.read(
        inventoryReportListNotifierProvider.notifier,
      );
      final detailNotifier = ref.read(
        inventoryReportDetailNotifierProvider.notifier,
      );

      return InventoryReportMutationNotifier(
        createInventoryReportUsecase,
        updateInventoryReportUsecase,
        deleteInventoryReportUsecase,
        listNotifier,
        detailNotifier,
      );
    });
