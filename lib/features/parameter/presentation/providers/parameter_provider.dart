import 'package:budidaya_lele_mobile/features/parameter/data/datasources/parameter_datasource.dart';
import 'package:budidaya_lele_mobile/features/parameter/data/repositories/parameter_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/repositories/parameter_repository.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/usecases/update_parameter_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Provider Datasource
final parameterDatasourceProvider = Provider((ref) => ParameterDatasource());

// Provider Repository
final parameterRepositoryProvider = Provider<ParameterRepository>((ref) {
  final datasource = ref.read(parameterDatasourceProvider);
  return ParameterRepositoryImpl(datasource);
});

// Provider Usecase
final updateParameterUseCaseProvider = Provider<UpdateParameterUsecase>((ref) {
  final repository = ref.read(parameterRepositoryProvider);
  return UpdateParameterUsecase(repository);
});

class ParameterMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final UpdateParameterUsecase _updateParameterUsecase;

  ParameterMutationNotifier(this._updateParameterUsecase)
    : super(const AsyncValue.data(null));

  // Update parameter
  Future<void> updateParameter(
    String poolId,
    String temperatureMax,
    String temperatureMin,
    String acidityMax,
    String acidityMin,
  ) async {
    state = const AsyncValue.loading();

    final result = await _updateParameterUsecase.execute(
      poolId,
      temperatureMax,
      temperatureMin,
      acidityMax,
      acidityMin,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah parameter',
          StackTrace.current,
        );
      },
      (parameter) {
        state = AsyncValue.data(null);
      },
    );
  }
}

// Parameter Mutation Notifier Provider
final parameterMutationNotifierProvider =
    StateNotifierProvider<ParameterMutationNotifier, AsyncValue<void>>((ref) {
      final updateParameterUsecase = ref.read(updateParameterUseCaseProvider);

      return ParameterMutationNotifier(updateParameterUsecase);
    });
