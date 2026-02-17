// Provider untuk Datasource
import 'package:budidaya_lele_mobile/features/schedule/data/datasources/feeding_datasource.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/repositories/feeding_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/feeding_repository.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/create_feeding_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/delete_feeding_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/get_feeding_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/get_feedings_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/update_feeding_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Provider Datasource
final feedingDatasourceProvider = Provider((ref) => FeedingDatasource());

// Provider Repository
final feedingRepositoryProvider = Provider<FeedingRepository>((ref) {
  final datasource = ref.read(feedingDatasourceProvider);
  return FeedingRepositoryImpl(datasource);
});

// Provider Usecase
final getFeedingsUseCaseProvider = Provider<GetFeedingsUsecase>((ref) {
  final repository = ref.read(feedingRepositoryProvider);
  return GetFeedingsUsecase(repository);
});

final getFeedingUseCaseProvider = Provider<GetFeedingUsecase>((ref) {
  final repository = ref.read(feedingRepositoryProvider);
  return GetFeedingUsecase(repository);
});

final createFeedingUseCaseProvider = Provider<CreateFeedingUsecase>((ref) {
  final repository = ref.read(feedingRepositoryProvider);
  return CreateFeedingUsecase(repository);
});

final updateFeedingUseCaseProvider = Provider<UpdateFeedingUsecase>((ref) {
  final repository = ref.read(feedingRepositoryProvider);
  return UpdateFeedingUsecase(repository);
});

final deleteFeedingUseCaseProvider = Provider<DeleteFeedingUsecase>((ref) {
  final repository = ref.read(feedingRepositoryProvider);
  return DeleteFeedingUsecase(repository);
});

// Notifier Provider
class FeedingListNotifier extends StateNotifier<AsyncValue<List<Schedule>>> {
  final GetFeedingsUsecase _getFeedingsUsecase;
  FeedingListNotifier(this._getFeedingsUsecase)
    : super(const AsyncValue.data([]));

  // Get all schedules
  Future<void> getFeedingSchedules() async {
    state = const AsyncValue.loading();
    final result = await _getFeedingsUsecase.execute();

    result.fold((failure) {
      state = AsyncValue.error(
        failure.message ?? 'Terjadi kesalahan',
        StackTrace.current,
      );
    }, (schedules) => state = AsyncValue.data(schedules));
  }
}

class FeedingDetailNotifier extends StateNotifier<AsyncValue<Schedule?>> {
  final GetFeedingUsecase _getFeedingUsecase;

  FeedingDetailNotifier(this._getFeedingUsecase)
    : super(const AsyncValue.data(null));

  // Get single schedule detail
  Future<void> getFeedingSchedule(String id) async {
    state = const AsyncValue.loading();
    final result = await _getFeedingUsecase.execute(id);

    result.fold((failure) {
      state = AsyncValue.error(
        failure.message ?? 'Terjadi kesalahan',
        StackTrace.current,
      );
    }, (schedule) => state = AsyncValue.data(schedule));
  }
}

class FeedingDeleteNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final DeleteFeedingUsecase _deleteFeedingUsecase;

  FeedingDeleteNotifier(this._deleteFeedingUsecase)
    : super(const AsyncValue.data({}));

  // Delete schedule
  Future<Map<String, dynamic>> deleteFeedingSchedule(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteFeedingUsecase.execute(id);

    return result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus jadwal',
          StackTrace.current,
        );
        return {
          'success': false,
          'message': failure.message ?? 'Gagal menghapus jadwal',
        };
      },
      (data) {
        state = AsyncValue.data(data);
        return data;
      },
    );
  }
}

class FeedingMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateFeedingUsecase _createFeedingUsecase;
  final UpdateFeedingUsecase _updateFeedingUsecase;
  final DeleteFeedingUsecase _deleteFeedingUsecase;
  final FeedingListNotifier _listNotifier;
  final FeedingDetailNotifier _detailNotifier;

  FeedingMutationNotifier(
    this._createFeedingUsecase,
    this._updateFeedingUsecase,
    this._deleteFeedingUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Create feeding schedule
  Future<void> createFeedingSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createFeedingUsecase.execute(
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
        _listNotifier.getFeedingSchedules();
      },
    );
  }

  // Update feeding schedule
  Future<void> updateFeedingSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updateFeedingUsecase.execute(
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
        _listNotifier.getFeedingSchedules();
        _detailNotifier.getFeedingSchedule(id);
      },
    );
  }

  // Delete feeding schedule
  Future<void> deleteFeedingSchedule(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteFeedingUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus jadwal',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getFeedingSchedules();
      },
    );
  }
}

// Provider Utama
// Feeding List Notifier Provider
final feedingListNotifierProvider =
    StateNotifierProvider<FeedingListNotifier, AsyncValue<List<Schedule>>>((
      ref,
    ) {
      final getFeedingsUsecase = ref.read(getFeedingsUseCaseProvider);
      return FeedingListNotifier(getFeedingsUsecase);
    });

// Feeding Detail Notifier Provider
final feedingDetailNotifierProvider =
    StateNotifierProvider<FeedingDetailNotifier, AsyncValue<Schedule?>>((ref) {
      final getFeedingUsecase = ref.read(getFeedingUseCaseProvider);
      return FeedingDetailNotifier(getFeedingUsecase);
    });

// Feeding Delete Notifier Provider
final feedingDeleteNotifierProvider =
    StateNotifierProvider<
      FeedingDeleteNotifier,
      AsyncValue<Map<String, dynamic>>
    >((ref) {
      final deleteFeedingUsecase = ref.read(deleteFeedingUseCaseProvider);
      return FeedingDeleteNotifier(deleteFeedingUsecase);
    });

// Feeding Mutation Notifier Provider
final feedingMutationNotifierProvider =
    StateNotifierProvider<FeedingMutationNotifier, AsyncValue<void>>((ref) {
      final createFeedingUsecase = ref.read(createFeedingUseCaseProvider);
      final updateFeedingUsecase = ref.read(updateFeedingUseCaseProvider);
      final deleteFeedingUsecase = ref.read(deleteFeedingUseCaseProvider);
      final listNotifier = ref.read(feedingListNotifierProvider.notifier);
      final detailNotifier = ref.read(feedingDetailNotifierProvider.notifier);

      return FeedingMutationNotifier(
        createFeedingUsecase,
        updateFeedingUsecase,
        deleteFeedingUsecase,
        listNotifier,
        detailNotifier,
      );
    });
