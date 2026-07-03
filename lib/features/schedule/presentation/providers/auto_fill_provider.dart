import 'package:budidaya_lele_mobile/features/schedule/data/datasources/auto_fill_datasource.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/repositories/auto_fill_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/auto_fill.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/auto_fill_repository.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/get_auto_fills_usecase.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
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
  final Ref _ref;

  AutoFillListNotifier(this._getAutoFillsUsecase, this._ref)
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
    }, (autoFills) {
      // Backend mengembalikan semua petugas berakses kolam, termasuk user yang
      // sudah dihapus dan PIC yang sedang login. Saring keduanya: hanya petugas
      // aktif (deletedAt == null) dan bukan diri sendiri yang boleh dipilih.
      final currentUserId = _ref.read(userProvider)?.id;
      final filtered = autoFills
          .where((a) => a.deletedAt == null && a.id != currentUserId)
          .toList();
      state = AsyncValue.data(filtered);
    });
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

      return AutoFillListNotifier(getAutoFillsUsecase, ref);
    });
