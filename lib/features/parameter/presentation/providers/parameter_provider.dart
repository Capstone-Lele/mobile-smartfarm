import 'package:budidaya_lele_mobile/features/parameter/data/datasources/parameter_datasource.dart';
import 'package:budidaya_lele_mobile/features/parameter/data/repositories/parameter_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/repositories/parameter_repository.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/usecases/update_parameter_usecase.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/usecases/update_parameters_usecase.dart';
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

final updateParametersUseCaseProvider = Provider<UpdateParametersUsecase>((
  ref,
) {
  final repository = ref.read(parameterRepositoryProvider);
  return UpdateParametersUsecase(repository);
});

class ParameterMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final UpdateParameterUsecase _updateParameterUsecase;
  final UpdateParametersUsecase _updateParametersUsecase;

  ParameterMutationNotifier(
    this._updateParameterUsecase,
    this._updateParametersUsecase,
  ) : super(const AsyncValue.data(null));

  // Update parameter by pool id
  Future<void> updateParameter(
    String poolId,
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) async {
    state = const AsyncValue.loading();

    final result = await _updateParameterUsecase.execute(
      poolId,
      temperatureMax,
      temperatureNormal,
      temperatureMin,
      acidityMax,
      acidityNormal,
      acidityMin,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah parameter kolam',
          StackTrace.current,
        );
      },
      (_) {
        state = const AsyncValue.data(null);
      },
    );
  }

  // Update parameter globally
  Future<void> updateParameters(
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) async {
    state = const AsyncValue.loading();

    final result = await _updateParametersUsecase.execute(
      temperatureMax,
      temperatureNormal,
      temperatureMin,
      acidityMax,
      acidityNormal,
      acidityMin,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah parameter global',
          StackTrace.current,
        );
      },
      (_) {
        state = const AsyncValue.data(null);
      },
    );
  }
}

// Parameter Mutation Notifier Provider
final parameterMutationNotifierProvider =
    StateNotifierProvider<ParameterMutationNotifier, AsyncValue<void>>((ref) {
      final updateParameterUsecase = ref.read(updateParameterUseCaseProvider);
      final updateParametersUsecase = ref.read(updateParametersUseCaseProvider);

      return ParameterMutationNotifier(
        updateParameterUsecase,
        updateParametersUsecase,
      );
    });
