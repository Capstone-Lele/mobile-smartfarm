import 'package:budidaya_lele_mobile/features/schedule/data/datasource/cleaning_datasource.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/repositories/cleaning_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/cleaning_repository.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/create_cleaning_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/delete_cleaning_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/get_cleaning_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/get_cleanings_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/update_cleaning_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Datasource Provider
final cleaningDatasourceProvider = Provider((ref) => CleaningDatasource());

// Repository Provider
final cleaningRepositoryProvider = Provider<CleaningRepository>((ref) {
  final datasource = ref.read(cleaningDatasourceProvider);
  return CleaningRepositoryImpl(datasource);
});

// Usecase Providers
final getCleaningsUseCaseProvider = Provider<GetCleaningsUsecase>((ref) {
  final repository = ref.read(cleaningRepositoryProvider);
  return GetCleaningsUsecase(repository);
});

final getCleaningUseCaseProvider = Provider<GetCleaningUsecase>((ref) {
  final repository = ref.read(cleaningRepositoryProvider);
  return GetCleaningUsecase(repository);
});

final createCleaningUseCaseProvider = Provider<CreateCleaningUsecase>((ref) {
  final repository = ref.read(cleaningRepositoryProvider);
  return CreateCleaningUsecase(repository);
});

final updateCleaningUseCaseProvider = Provider<UpdateCleaningUsecase>((ref) {
  final repository = ref.read(cleaningRepositoryProvider);
  return UpdateCleaningUsecase(repository);
});

final deleteCleaningUseCaseProvider = Provider<DeleteCleaningUsecase>((ref) {
  final repository = ref.read(cleaningRepositoryProvider);
  return DeleteCleaningUsecase(repository);
});

// Notifier Provider
class CleaningListNotifier extends StateNotifier<AsyncValue<List<Schedule>>> {
  final GetCleaningsUsecase _getCleaningsUsecase;

  CleaningListNotifier(this._getCleaningsUsecase)
    : super(const AsyncValue.data([]));

  // Get all schedules
  Future<void> getCleaningSchedules() async {
    state = const AsyncValue.loading();
    final result = await _getCleaningsUsecase.execute();

    result.fold((failure) {
      state = AsyncValue.error(
        failure.message ?? 'Terjadi kesalahan',
        StackTrace.current,
      );
    }, (schedules) => state = AsyncValue.data(schedules));
  }
}

class CleaningDetailNotifier extends StateNotifier<AsyncValue<Schedule?>> {
  final GetCleaningUsecase _getCleaningUsecase;

  CleaningDetailNotifier(this._getCleaningUsecase)
    : super(const AsyncValue.data(null));

  // Get single schedule detail
  Future<void> getCleaningSchedule(String id) async {
    state = const AsyncValue.loading();
    final result = await _getCleaningUsecase.execute(id);

    result.fold((failure) {
      state = AsyncValue.error(
        failure.message ?? 'Terjadi kesalahan',
        StackTrace.current,
      );
    }, (schedule) => state = AsyncValue.data(schedule));
  }
}

class CleaningMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateCleaningUsecase _createCleaningUsecase;
  final UpdateCleaningUsecase _updateCleaningUsecase;
  final DeleteCleaningUsecase _deleteCleaningUsecase;
  final CleaningListNotifier _listNotifier;
  final CleaningDetailNotifier _detailNotifier;

  CleaningMutationNotifier(
    this._createCleaningUsecase,
    this._updateCleaningUsecase,
    this._deleteCleaningUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Create cleaning schedule
  Future<void> createCleaningSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createCleaningUsecase.execute(
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
        _listNotifier.getCleaningSchedules();
      },
    );
  }

  // Update cleaning schedule
  Future<void> updateCleaningSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updateCleaningUsecase.execute(
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
        _listNotifier.getCleaningSchedules();
        _detailNotifier.getCleaningSchedule(id);
      },
    );
  }

  // Delete cleaning schedule
  Future<void> deleteCleaningSchedule(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteCleaningUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus jadwal',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getCleaningSchedules();
      },
    );
  }
}

// provider Utama
// Cleaning List Notifier Provider
final cleaningListNotifierProvider =
    StateNotifierProvider<CleaningListNotifier, AsyncValue<List<Schedule>>>((
      ref,
    ) {
      final getCleaningsUsecase = ref.read(getCleaningsUseCaseProvider);

      return CleaningListNotifier(getCleaningsUsecase);
    });

// Cleaning Detail Notifier Provider
final cleaningDetailNotifierProvider =
    StateNotifierProvider<CleaningDetailNotifier, AsyncValue<Schedule?>>((ref) {
      final getCleaningUsecase = ref.read(getCleaningUseCaseProvider);
      return CleaningDetailNotifier(getCleaningUsecase);
    });

// Cleaning Mutation Notifier Provider
final cleaningMutationNotifierProvider =
    StateNotifierProvider<CleaningMutationNotifier, AsyncValue<void>>((ref) {
      final createCleaningUsecase = ref.read(createCleaningUseCaseProvider);
      final updateCleaningUsecase = ref.read(updateCleaningUseCaseProvider);
      final deleteCleaningUsecase = ref.read(deleteCleaningUseCaseProvider);
      final listNotifier = ref.read(cleaningListNotifierProvider.notifier);
      final detailNotifier = ref.read(cleaningDetailNotifierProvider.notifier);

      return CleaningMutationNotifier(
        createCleaningUsecase,
        updateCleaningUsecase,
        deleteCleaningUsecase,
        listNotifier,
        detailNotifier,
      );
    });
