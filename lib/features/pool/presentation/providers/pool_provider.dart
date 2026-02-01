import 'package:budidaya_lele_mobile/features/pool/data/datasource/pool_datasource.dart';
import 'package:budidaya_lele_mobile/features/pool/data/repositories/pool_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
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

// provider utama
// Pool List Notifier Provider
final poolListNotifierProvider = StateNotifierProvider<PoolListNotifier, AsyncValue<List<Pool>>>((ref){
  final getPoolsUseCase = ref.read(getPoolsUseCaseProvider);
  return PoolListNotifier(getPoolsUseCase);
});