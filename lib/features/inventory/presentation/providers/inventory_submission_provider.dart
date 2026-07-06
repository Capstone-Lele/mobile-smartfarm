// Provider Datasource
import 'package:budidaya_lele_mobile/features/inventory/data/datasources/inventory_submission_datasource.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/repositories/inventory_submission_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_submission_repository.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/create_inventory_submission_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/delete_inventory_submission_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/get_inventory_submission_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/get_inventory_submissions_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/update_inventory_submission_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final inventorySubmissionDatasourceProvider = Provider(
  (ref) => InventorySubmissionDatasource(),
);

// Provider Repository
final inventorySubmissionRepositoryProvider =
    Provider<InventorySubmissionRepository>((ref) {
      final datasource = ref.read(inventorySubmissionDatasourceProvider);
      return InventorySubmissionRepositoryImpl(datasource);
    });

// Provider Usecase
final getInventorySubmissionsUseCaseProvider =
    Provider<GetInventorySubmissionsUsecase>((ref) {
      final repository = ref.read(inventorySubmissionRepositoryProvider);
      return GetInventorySubmissionsUsecase(repository);
    });

final getInventorySubmissionUseCaseProvider =
    Provider<GetInventorySubmissionUsecase>((ref) {
      final repository = ref.read(inventorySubmissionRepositoryProvider);
      return GetInventorySubmissionUsecase(repository);
    });

final createInventorySubmissionUseCaseProvider =
    Provider<CreateInventorySubmissionUsecase>((ref) {
      final repository = ref.read(inventorySubmissionRepositoryProvider);
      return CreateInventorySubmissionUsecase(repository);
    });

final updateInventorySubmissionUseCaseProvider =
    Provider<UpdateInventorySubmissionUsecase>((ref) {
      final repository = ref.read(inventorySubmissionRepositoryProvider);
      return UpdateInventorySubmissionUsecase(repository);
    });

final deleteInventorySubmissionUseCaseProvider =
    Provider<DeleteInventorySubmissionUsecase>((ref) {
      final repository = ref.read(inventorySubmissionRepositoryProvider);
      return DeleteInventorySubmissionUsecase(repository);
    });

class InventorySubmissionListNotifier
    extends StateNotifier<AsyncValue<List<InventorySubmission>>> {
  final GetInventorySubmissionsUsecase _getInventorySubmissionsUsecase;

  InventorySubmissionListNotifier(this._getInventorySubmissionsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getInventorySubmissions() async {
    state = const AsyncValue.loading();
    final result = await _getInventorySubmissionsUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (inventorySubmissions) {
        state = AsyncValue.data(inventorySubmissions);
      },
    );
  }
}

class InventorySubmissionDetailNotifier
    extends StateNotifier<AsyncValue<InventorySubmissionDetail?>> {
  final GetInventorySubmissionUsecase _getInventorySubmissionUsecase;

  InventorySubmissionDetailNotifier(this._getInventorySubmissionUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getInventorySubmission(String id) async {
    state = const AsyncValue.loading();
    final result = await _getInventorySubmissionUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (inventorySubmission) {
        state = AsyncValue.data(inventorySubmission);
      },
    );
  }
}

class InventorySubmissionMutationNotifier
    extends StateNotifier<AsyncValue<void>> {
  final CreateInventorySubmissionUsecase _createInventorySubmissionUsecase;
  final UpdateInventorySubmissionUsecase _updateInventorySubmissionUsecase;
  final DeleteInventorySubmissionUsecase _deleteInventorySubmissionUsecase;
  final InventorySubmissionListNotifier _listNotifier;
  final InventorySubmissionDetailNotifier _detailNotifier;

  InventorySubmissionMutationNotifier(
    this._createInventorySubmissionUsecase,
    this._updateInventorySubmissionUsecase,
    this._deleteInventorySubmissionUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Create Inventory Submission
  Future<void> createInventorySubmission(
    String inventoryId,
    int quantity,
    String transactionType,
    String notes,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createInventorySubmissionUsecase.execute(
      inventoryId,
      quantity,
      transactionType,
      notes,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat pengajuan inventaris',
          StackTrace.current,
        );
      },
      (inventorySubmission) {
        state = AsyncValue.data(null);
        _listNotifier.getInventorySubmissions();
      },
    );
  }

  // Update inventory submission
  Future<void> updateInventorySubmission(
    String id,
    String inventoryId,
    int quantity,
    String transactionType,
    String notes,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updateInventorySubmissionUsecase.execute(
      id,
      inventoryId,
      quantity,
      transactionType,
      notes,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah pengajuan inventaris',
          StackTrace.current,
        );
      },
      (inventorySubmission) {
        state = AsyncValue.data(null);
        _listNotifier.getInventorySubmissions();
        _detailNotifier.getInventorySubmission(id);
      },
    );
  }

  // Delete inventory submission
  Future<void> deleteInventorySubmission(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteInventorySubmissionUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus pengajuan inventaris',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getInventorySubmissions();
      },
    );
  }
}

// provider Utama
// Inventory Submission List Notifier Provider
final inventorySubmissionListNotifierProvider =
    StateNotifierProvider<
      InventorySubmissionListNotifier,
      AsyncValue<List<InventorySubmission>>
    >((ref) {
      final getInventorySubmissionsUsecase = ref.read(
        getInventorySubmissionsUseCaseProvider,
      );

      return InventorySubmissionListNotifier(getInventorySubmissionsUsecase);
    });

// Inventory Submission Detail Notifier Provider
final inventorySubmissionDetailNotifierProvider =
    StateNotifierProvider<
      InventorySubmissionDetailNotifier,
      AsyncValue<InventorySubmissionDetail?>
    >((ref) {
      final getInventorySubmissionUsecase = ref.read(
        getInventorySubmissionUseCaseProvider,
      );
      return InventorySubmissionDetailNotifier(getInventorySubmissionUsecase);
    });

  // Inventory Submission Mutation Notifier Provider
final inventorySubmissionMutationNotifierProvider =
    StateNotifierProvider<InventorySubmissionMutationNotifier, AsyncValue<void>>((
      ref,
    ) {
      final createInventorySubmissionUsecase = ref.read(
         createInventorySubmissionUseCaseProvider,
      );
      final updateInventorySubmissionUsecase = ref.read(
        updateInventorySubmissionUseCaseProvider,
      );
      final deleteInventorySubmissionUsecase = ref.read(
        deleteInventorySubmissionUseCaseProvider,
      );
      final listNotifier = ref.read(
        inventorySubmissionListNotifierProvider.notifier,
      );
      final detailNotifier = ref.read(
        inventorySubmissionDetailNotifierProvider.notifier,
      );

      return InventorySubmissionMutationNotifier(
        createInventorySubmissionUsecase,
        updateInventorySubmissionUsecase,
        deleteInventorySubmissionUsecase,
        listNotifier,
        detailNotifier,
      );
    });
