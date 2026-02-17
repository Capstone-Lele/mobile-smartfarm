// Datasource Provider
import 'package:budidaya_lele_mobile/features/schedule/data/datasources/sampling_datasource.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/repositories/sampling_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/sampling_repository.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/create_sampling_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/delete_sampling_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/get_sampling_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/get_samplings_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/update_sampling_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final samplingDatasourceProvider = Provider((ref) => SamplingDatasource());

// Repository Provider
final samplingRepositoryProvider = Provider<SamplingRepository>((ref) {
  final datasource = ref.read(samplingDatasourceProvider);
  return SamplingRepositoryImpl(datasource);
});

// Usecase Providers
final getSamplingsUseCaseProvider = Provider<GetSamplingsUsecase>((ref) {
  final repository = ref.read(samplingRepositoryProvider);
  return GetSamplingsUsecase(repository);
});

final getSamplingUseCaseProvider = Provider<GetSamplingUsecase>((ref) {
  final repository = ref.read(samplingRepositoryProvider);
  return GetSamplingUsecase(repository);
});

final createSamplingUseCaseProvider = Provider<CreateSamplingUsecase>((ref) {
  final repository = ref.read(samplingRepositoryProvider);
  return CreateSamplingUsecase(repository);
});

final updateSamplingUseCaseProvider = Provider<UpdateSamplingUsecase>((ref) {
  final repository = ref.read(samplingRepositoryProvider);
  return UpdateSamplingUsecase(repository);
});

final deleteSamplingUseCaseProvider = Provider<DeleteSamplingUsecase>((ref) {
  final repository = ref.read(samplingRepositoryProvider);
  return DeleteSamplingUsecase(repository);
});

// Notifier Provider
class SamplingListNotifier extends StateNotifier<AsyncValue<List<Schedule>>> {
  final GetSamplingsUsecase _getSamplingsUsecase;

  SamplingListNotifier(this._getSamplingsUsecase)
    : super(const AsyncValue.data([]));

  // Get all schedules
  Future<void> getSamplingSchedules() async {
    state = const AsyncValue.loading();
    final result = await _getSamplingsUsecase.execute();

    result.fold((failure) {
      state = AsyncValue.error(
        failure.message ?? 'Terjadi kesalahan',
        StackTrace.current,
      );
    }, (schedules) => state = AsyncValue.data(schedules));
  }
}

class SamplingDetailNotifier extends StateNotifier<AsyncValue<Schedule?>> {
  final GetSamplingUsecase _getSamplingUsecase;

  SamplingDetailNotifier(this._getSamplingUsecase)
    : super(const AsyncValue.data(null));

  // Get single schedule detail
  Future<void> getSamplingSchedule(String id) async {
    state = const AsyncValue.loading();
    final result = await _getSamplingUsecase.execute(id);

    result.fold((failure) {
      state = AsyncValue.error(
        failure.message ?? 'Terjadi kesalahan',
        StackTrace.current,
      );
    }, (schedule) => state = AsyncValue.data(schedule));
  }
}

class SamplingMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateSamplingUsecase _createSamplingUsecase;
  final UpdateSamplingUsecase _updateSamplingUsecase;
  final DeleteSamplingUsecase _deleteSamplingUsecase;
  final SamplingListNotifier _listNotifier;
  final SamplingDetailNotifier _detailNotifier;

  SamplingMutationNotifier(
    this._createSamplingUsecase,
    this._updateSamplingUsecase,
    this._deleteSamplingUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Create sampling schedule
  Future<void> createSamplingSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createSamplingUsecase.execute(
      poolId,
      userId,
      scheduleDate,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat jadwal',
          StackTrace.current,
        );
      },
      (schedule) {
        state = AsyncValue.data(null);
        _listNotifier.getSamplingSchedules();
      },
    );
  }

  // Update sampling schedule
  Future<void> updateSamplingSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updateSamplingUsecase.execute(
      id,
      poolId,
      userId,
      scheduleDate,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah jadwal',
          StackTrace.current,
        );
      },
      (schedule) {
        state = AsyncValue.data(null);
        _listNotifier.getSamplingSchedules();
        _detailNotifier.getSamplingSchedule(id);
      },
    );
  }

  // Delete sampling schedule
  Future<void> deleteSamplingSchedule(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteSamplingUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus jadwal',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getSamplingSchedules();
      },
    );
  }
}

// provider Utama
// Sampling List Notifier Provider
final samplingListNotifierProvider =
    StateNotifierProvider<SamplingListNotifier, AsyncValue<List<Schedule>>>((
      ref,
    ) {
      final getSamplingsUsecase = ref.read(getSamplingsUseCaseProvider);

      return SamplingListNotifier(getSamplingsUsecase);
    });

// Sampling Detail Notifier Provider
final samplingDetailNotifierProvider =
    StateNotifierProvider.autoDispose<
      SamplingDetailNotifier,
      AsyncValue<Schedule?>
    >((ref) {
      final getSamplingUsecase = ref.read(getSamplingUseCaseProvider);
      return SamplingDetailNotifier(getSamplingUsecase);
    });

// Sampling Mutation Notifier Provider
final samplingMutationNotifierProvider =
    StateNotifierProvider<SamplingMutationNotifier, AsyncValue<void>>((ref) {
      final createSamplingUsecase = ref.read(createSamplingUseCaseProvider);
      final updateSamplingUsecase = ref.read(updateSamplingUseCaseProvider);
      final deleteSamplingUsecase = ref.read(deleteSamplingUseCaseProvider);
      final listNotifier = ref.read(samplingListNotifierProvider.notifier);
      final detailNotifier = ref.read(samplingDetailNotifierProvider.notifier);

      return SamplingMutationNotifier(
        createSamplingUsecase,
        updateSamplingUsecase,
        deleteSamplingUsecase,
        listNotifier,
        detailNotifier,
      );
    });
