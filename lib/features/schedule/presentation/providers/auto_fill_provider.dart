import 'package:budidaya_lele_mobile/features/schedule/data/datasource/auto_fill_datasource.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/repositories/auto_fill_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/auto_fill.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/auto_fill_repository.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/get_auto_fills_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Datasource Provider
final autoFillDatasourceProvider = Provider((ref) => AutoFillDatasource());

// Repository Provider
final autoFillRepositoryProvider = Provider<AutoFillRepository>((ref) {
  final datasource = ref.read(autoFillDatasourceProvider);
  return AutoFillRepositoryImpl(datasource);
});

// Usecase Providers
final getAutoFillsUseCaseProvider = Provider<GetAutoFillsUsecase>((ref) {
  final repository = ref.read(autoFillRepositoryProvider);
  return GetAutoFillsUsecase(repository);
});

// Notifier Provider
class AutoFillListNotifier extends StateNotifier<AsyncValue<List<AutoFill>>> {
  final GetAutoFillsUsecase _getAutoFillsUsecase;

  AutoFillListNotifier(this._getAutoFillsUsecase)
    : super(const AsyncValue.data([]));

  // Get all auto fills
  Future<void> getAutoFills(String id) async {
    state = const AsyncValue.loading();
    final result = await _getAutoFillsUsecase.execute(id);

    result.fold((failure) {
      state = AsyncValue.error(
        failure.message ?? 'Terjadi kesalahan',
        StackTrace.current,
      );
    }, (autoFills) => state = AsyncValue.data(autoFills));
  }
}

// provider Utama
// Auto Fill List Notifier Provider
final autoFillListNotifierProvider =
    StateNotifierProvider.autoDispose<
      AutoFillListNotifier,
      AsyncValue<List<AutoFill>>
    >((ref) {
      final getAutoFillsUsecase = ref.read(getAutoFillsUseCaseProvider);

      return AutoFillListNotifier(getAutoFillsUsecase);
    });
