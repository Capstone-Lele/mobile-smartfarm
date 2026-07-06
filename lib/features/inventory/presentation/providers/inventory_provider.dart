import 'package:budidaya_lele_mobile/features/inventory/data/datasources/inventory_datasource.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory/get_inventories_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory/get_inventory_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final inventoryTabProvider = StateProvider<int>((ref) => 0);
final inventoryCategoryProvider = StateProvider<int>((ref) => 0);

// Provider Datasource
final inventoryDatasourceProvider = Provider((ref) => InventoryDatasource());

// Provider Repository
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final datasource = ref.read(inventoryDatasourceProvider);
  return InventoryRepositoryImpl(datasource);
});

// Provider Usecase
final getInventoriesUseCaseProvider = Provider<GetInventoriesUsecase>((ref) {
  final repository = ref.read(inventoryRepositoryProvider);
  return GetInventoriesUsecase(repository);
});

final getInventoryUseCaseProvider = Provider<GetInventoryUsecase>((ref) {
  final repository = ref.read(inventoryRepositoryProvider);
  return GetInventoryUsecase(repository);
});

class InventoryListNotifier extends StateNotifier<AsyncValue<List<Inventory>>> {
  final GetInventoriesUsecase _getInventoriesUsecase;

  InventoryListNotifier(this._getInventoriesUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getInventories() async {
    state = const AsyncValue.loading();
    final result = await _getInventoriesUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (inventories) {
        // Backend tetap mengembalikan inventory yang sudah dihapus (soft
        // delete), jadi saring agar hanya yang deletedAt == null yang tampil.
        final activeInventories = inventories
            .where((item) => item.deletedAt == null)
            .toList();
        state = AsyncValue.data(activeInventories);
      },
    );
  }
}

class InventoryDetailNotifier extends StateNotifier<AsyncValue<InventoryDetail?>> {
  final GetInventoryUsecase _getInventoryUsecase;

  InventoryDetailNotifier(this._getInventoryUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getInventory(String id) async {
    state = const AsyncValue.loading();
    final result = await _getInventoryUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (inventory) {
        state = AsyncValue.data(inventory);
      },
    );
  }
}

// provider Utama
// Inventory List Notifier Provider
final inventoryListNotifierProvider =
    StateNotifierProvider<
      InventoryListNotifier,
      AsyncValue<List<Inventory>>
    >((ref) {
      final getInventoriesUsecase = ref.read(
        getInventoriesUseCaseProvider,
      );

      return InventoryListNotifier(getInventoriesUsecase);
    });

// Inventory Detail Notifier Provider
final inventoryDetailNotifierProvider =
    StateNotifierProvider<
      InventoryDetailNotifier,
      AsyncValue<InventoryDetail?>
    >((ref) {
      final getInventoryUsecase = ref.read(
        getInventoryUseCaseProvider,
      );
      return InventoryDetailNotifier(getInventoryUsecase);
    });
