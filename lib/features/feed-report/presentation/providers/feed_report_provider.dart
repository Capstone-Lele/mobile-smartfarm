import 'package:budidaya_lele_mobile/features/feed-report/data/datasources/feed_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/feed-report/data/repositories/feed_report_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/repositories/feed_report_repository.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/create_feed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/delete_feed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/get_feed_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/get_feed_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/usecases/update_feed_report_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final feedReportDatasourceProvider = Provider((ref) => FeedReportDatasource());

// Provider Repository
final feedReportRepositoryProvider = Provider<FeedReportRepository>((ref) {
  final datasource = ref.read(feedReportDatasourceProvider);
  return FeedReportRepositoryImpl(datasource);
});

// Provider Usecase
final getFeedReportsUseCaseProvider = Provider<GetFeedReportsUsecase>((ref) {
  final repository = ref.read(feedReportRepositoryProvider);
  return GetFeedReportsUsecase(repository);
});

final getFeedReportUseCaseProvider = Provider<GetFeedReportUsecase>((ref) {
  final repository = ref.read(feedReportRepositoryProvider);
  return GetFeedReportUsecase(repository);
});

final createFeedReportUseCaseProvider = Provider<CreateFeedReportUsecase>((
  ref,
) {
  final repository = ref.read(feedReportRepositoryProvider);
  return CreateFeedReportUsecase(repository);
});

final updateFeedReportUseCaseProvider = Provider<UpdateFeedReportUsecase>((
  ref,
) {
  final repository = ref.read(feedReportRepositoryProvider);
  return UpdateFeedReportUsecase(repository);
});

final deleteFeedReportUseCaseProvider = Provider<DeleteFeedReportUsecase>((
  ref,
) {
  final repository = ref.read(feedReportRepositoryProvider);
  return DeleteFeedReportUsecase(repository);
});

class FeedReportListNotifier
    extends StateNotifier<AsyncValue<List<FeedReport>>> {
  final GetFeedReportsUsecase _getFeedReportsUsecase;

  FeedReportListNotifier(this._getFeedReportsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getFeedReports() async {
    state = const AsyncValue.loading();
    final result = await _getFeedReportsUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (feedReports) {
        state = AsyncValue.data(feedReports);
      },
    );
  }
}

class FeedReportDetailNotifier extends StateNotifier<AsyncValue<FeedReport?>> {
  final GetFeedReportUsecase _getFeedReportUsecase;

  FeedReportDetailNotifier(this._getFeedReportUsecase)
    : super(const AsyncValue.data(null));

  Future<void> getFeedReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _getFeedReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (feedReport) {
        state = AsyncValue.data(feedReport);
      },
    );
  }
}

class FeedReportMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateFeedReportUsecase _createFeedReportUsecase;
  final UpdateFeedReportUsecase _updateFeedReportUsecase;
  final DeleteFeedReportUsecase _deleteFeedReportUsecase;
  final FeedReportListNotifier _listNotifier;
  final FeedReportDetailNotifier _detailNotifier;

  FeedReportMutationNotifier(
    this._createFeedReportUsecase,
    this._updateFeedReportUsecase,
    this._deleteFeedReportUsecase,
    this._listNotifier,
    this._detailNotifier,
  ) : super(const AsyncValue.data(null));

  // Create Feed Report
  Future<void> createFeedReport(
    String cycleId,
    String userId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _createFeedReportUsecase.execute(
      cycleId,
      userId,
      inventoryId,
      reportDate,
      quantity,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal membuat laporan pakan',
          StackTrace.current,
        );
      },
      (feedReport) {
        state = AsyncValue.data(null);
        _listNotifier.getFeedReports();
      },
    );
  }

  // Update feed report
  Future<void> updateFeedReport(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile? image,
  ) async {
    state = const AsyncValue.loading();
    final result = await _updateFeedReportUsecase.execute(
      id,
      inventoryId,
      reportDate,
      quantity,
      image,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah laporan pakan',
          StackTrace.current,
        );
      },
      (feedReport) {
        state = AsyncValue.data(null);
        _listNotifier.getFeedReports();
        _detailNotifier.getFeedReport(id);
      },
    );
  }

  // Delete feed report
  Future<void> deleteFeedReport(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteFeedReportUsecase.execute(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal menghapus laporan pakan',
          StackTrace.current,
        );
      },
      (data) {
        state = AsyncValue.data(null);
        _listNotifier.getFeedReports();
      },
    );
  }
}

// provider Utama
// Feed Report List Notifier Provider
final feedReportListNotifierProvider =
    StateNotifierProvider<FeedReportListNotifier, AsyncValue<List<FeedReport>>>((
      ref,
    ) {
      final getFeedReportsUsecase = ref.read(getFeedReportsUseCaseProvider);

      return FeedReportListNotifier(getFeedReportsUsecase);
    });

// Feed Report Detail Notifier Provider
final feedReportDetailNotifierProvider =
    StateNotifierProvider<
      FeedReportDetailNotifier,
      AsyncValue<FeedReport?>
    >((ref) {
      final getFeedReportUsecase = ref.read(getFeedReportUseCaseProvider);
      return FeedReportDetailNotifier(getFeedReportUsecase);
    });

// Feed Report Mutation Notifier Provider
final feedReportMutationNotifierProvider =
    StateNotifierProvider<FeedReportMutationNotifier, AsyncValue<void>>((ref) {
      final createFeedReportUsecase = ref.read(createFeedReportUseCaseProvider);
      final updateFeedReportUsecase = ref.read(updateFeedReportUseCaseProvider);
      final deleteFeedReportUsecase = ref.read(deleteFeedReportUseCaseProvider);
      final listNotifier = ref.read(feedReportListNotifierProvider.notifier);
      final detailNotifier = ref.read(feedReportDetailNotifierProvider.notifier);

      return FeedReportMutationNotifier(
        createFeedReportUsecase,
        updateFeedReportUsecase,
        deleteFeedReportUsecase,
        listNotifier,
        detailNotifier,
      );
    });
