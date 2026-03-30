import 'package:budidaya_lele_mobile/features/pool/data/datasource/pool_datasource.dart';
import 'package:budidaya_lele_mobile/features/pool/data/repositories/pool_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/usecases/get_pool_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/usecases/get_pools_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Datasource Provider
final poolDatasourceProvider = Provider((ref) => PoolDatasource());

// Repository Provider
final poolRepositoryProvider = Provider<PoolRepository>((ref) {
  final datasource = ref.read(poolDatasourceProvider);
  return PoolRepositoryImpl(datasource);
});

// Usecase Providers
final getPoolsUseCaseProvider = Provider<GetPoolsUsecase>((ref) {
  final repository = ref.read(poolRepositoryProvider);
  return GetPoolsUsecase(repository);
});

final getPoolUseCaseProvider = Provider<GetPoolUsecase>((ref) {
  final repository = ref.read(poolRepositoryProvider);
  return GetPoolUsecase(repository);
});

class PoolListNotifier extends StateNotifier<AsyncValue<List<Pool>>> {
  final GetPoolsUsecase _getPoolsUsecase;

  PoolListNotifier(this._getPoolsUsecase) : super(const AsyncValue.data([]));

  // Get all pools
  Future<void> getPools() async {
    state = const AsyncValue.loading();
    final result = await _getPoolsUsecase.execute();

    result.fold((failure) {
      state = AsyncValue.error(
        failure.message ?? 'Terjadi Kesalahan',
        StackTrace.current,
      );
    }, (pools) => state = AsyncValue.data(pools));
  }
}

class PoolDetailNotifier extends StateNotifier<AsyncValue<Pool?>> {
  final GetPoolUsecase _getPoolUsecase;

  PoolDetailNotifier(this._getPoolUsecase) : super(const AsyncValue.data(null));

  // Get pool
  Future<void> getPool(String id) async {
    state = const AsyncValue.loading();
    final result = await _getPoolUsecase.execute(id);

    result.fold((failure) {
      state = AsyncValue.error(
        failure.message ?? 'Terjadi Kesalahan',
        StackTrace.current,
      );
    }, (pool) => state = AsyncValue.data(pool));
  }
}

// provider utama
// Pool List Notifier Provider
final poolListNotifierProvider =
    StateNotifierProvider<PoolListNotifier, AsyncValue<List<Pool>>>((ref) {
      final getPoolsUseCase = ref.read(getPoolsUseCaseProvider);
      return PoolListNotifier(getPoolsUseCase);
    });

// Pool Detail Notifier Provider
final poolDetailNotifierProvider =
    StateNotifierProvider<PoolDetailNotifier, AsyncValue<Pool?>>((ref) {
      final getPoolUseCase = ref.read(getPoolUseCaseProvider);
      return PoolDetailNotifier(getPoolUseCase);
    });
