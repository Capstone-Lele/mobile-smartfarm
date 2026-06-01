import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/feeding_repository.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/create_feeding_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/delete_feeding_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/get_feeding_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/get_feedings_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/feeding/update_feeding_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/feeding_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeFeedingRepository implements FeedingRepository {
  Future<Either<Failure, List<Schedule>>> Function()? _getListCallback;
  Future<Either<Failure, Schedule>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String, String, String)? _createCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String, String, String, String)? _updateCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String)? _deleteCallback;

  void setupGetList(Future<Either<Failure, List<Schedule>>> Function() callback) => _getListCallback = callback;
  void setupGet(Future<Either<Failure, Schedule>> Function(String) callback) => _getCallback = callback;
  void setupCreate(Future<Either<Failure, Map<String, dynamic>>> Function(String, String, String) callback) => _createCallback = callback;
  void setupUpdate(Future<Either<Failure, Map<String, dynamic>>> Function(String, String, String, String) callback) => _updateCallback = callback;
  void setupDelete(Future<Either<Failure, Map<String, dynamic>>> Function(String) callback) => _deleteCallback = callback;

  @override
  Future<Either<Failure, List<Schedule>>> getFeedingSchedules() {
    if (_getListCallback != null) return _getListCallback!();
    return Future.value(Right<Failure, List<Schedule>>([]));
  }

  @override
  Future<Either<Failure, Schedule>> getFeedingSchedule(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createFeedingSchedule(String poolId, String userId, String scheduleDate) {
    if (_createCallback != null) return _createCallback!(poolId, userId, scheduleDate);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateFeedingSchedule(String id, String poolId, String userId, String scheduleDate) {
    if (_updateCallback != null) return _updateCallback!(id, poolId, userId, scheduleDate);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteFeedingSchedule(String id) {
    if (_deleteCallback != null) return _deleteCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

Schedule _makeSchedule({String id = 'sch-1', String? date}) => Schedule(
  id: id,
  poolName: 'Kolam A',
  userName: 'John Doe',
  scheduleDate: date ?? '2024-09-01T00:00:00.000Z',
  type: 'feeding',
  createdAt: '2024-09-01T00:00:00.000Z',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeFeedingRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeFeedingRepository();
  });

  group('FeedingListNotifier', () {
    late FeedingListNotifier notifier;

    setUp(() {
      notifier = FeedingListNotifier(GetFeedingsUsecase(fakeRepository));
    });

    test('getFeedingSchedules should return data on success', () async {
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([_makeSchedule()]));

      await notifier.getFeedingSchedules();

      expect(notifier.state, isA<AsyncData<List<Schedule>>>());
      expect(notifier.state.value!.length, 1);
    });

    test('feedingListNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getFeedingsUseCaseProvider.overrideWithValue(GetFeedingsUsecase(fakeRepository)),
        ],
      );
      final state = container.read(feedingListNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getFeedingSchedules should emit error state on network failure', () async {
      fakeRepository.setupGetList(() async => Left<Failure, List<Schedule>>(FetchFailure('Network error')));

      await notifier.getFeedingSchedules();

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('FeedingDetailNotifier', () {
    late FeedingDetailNotifier notifier;

    setUp(() {
      notifier = FeedingDetailNotifier(GetFeedingUsecase(fakeRepository));
    });

    test('getFeedingSchedule should return detail on success', () async {
      fakeRepository.setupGet((id) async => Right<Failure, Schedule>(_makeSchedule()));

      await notifier.getFeedingSchedule('sch-1');

      expect(notifier.state, isA<AsyncData<Schedule?>>());
      expect(notifier.state.value!.id, 'sch-1');
    });

    test('feedingDetailNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getFeedingUseCaseProvider.overrideWithValue(GetFeedingUsecase(fakeRepository)),
        ],
      );
      final state = container.read(feedingDetailNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getFeedingSchedule should emit error state on network failure', () async {
      fakeRepository.setupGet((id) async => Left<Failure, Schedule>(FetchFailure('Network error')));

      await notifier.getFeedingSchedule('sch-1');

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });


  group('FeedingMutationNotifier', () {
    late FeedingListNotifier listNotifier;
    late FeedingDetailNotifier detailNotifier;
    late FeedingMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = FeedingListNotifier(GetFeedingsUsecase(fakeRepository));
      detailNotifier = FeedingDetailNotifier(GetFeedingUsecase(fakeRepository));
      mutationNotifier = FeedingMutationNotifier(
        CreateFeedingUsecase(fakeRepository),
        UpdateFeedingUsecase(fakeRepository),
        DeleteFeedingUsecase(fakeRepository),
        listNotifier,
        detailNotifier,
      );
    });

    test('createFeedingSchedule should return data on success', () async {
      fakeRepository.setupCreate((poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-new'}));
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([]));

      await mutationNotifier.createFeedingSchedule('pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createFeedingSchedule should refresh list after success', () async {
      var listRefreshed = false;
      fakeRepository.setupCreate((poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-new'}));
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<Schedule>>([]);
      });

      await mutationNotifier.createFeedingSchedule('pool-1', 'user-1', '2024-09-01');

      expect(listRefreshed, true);
    });

    test('createFeedingSchedule should emit error state on network failure', () async {
      fakeRepository.setupCreate((poolId, userId, date) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')));

      await mutationNotifier.createFeedingSchedule('pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('updateFeedingSchedule should return data on success', () async {
      fakeRepository.setupUpdate((id, poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-1'}));
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([]));
      fakeRepository.setupGet((id) async => Right<Failure, Schedule>(_makeSchedule()));

      await mutationNotifier.updateFeedingSchedule('sch-1', 'pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('updateFeedingSchedule should refresh list and detail after success', () async {
      var listRefreshed = false;
      var detailRefreshed = false;
      fakeRepository.setupUpdate((id, poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-1'}));
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<Schedule>>([]);
      });
      fakeRepository.setupGet((id) async {
        detailRefreshed = true;
        return Right<Failure, Schedule>(_makeSchedule());
      });

      await mutationNotifier.updateFeedingSchedule('sch-1', 'pool-1', 'user-1', '2024-09-01');

      expect(listRefreshed, true);
      expect(detailRefreshed, true);
    });

    test('updateFeedingSchedule should emit error state on network failure', () async {
      fakeRepository.setupUpdate((id, poolId, userId, date) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')));

      await mutationNotifier.updateFeedingSchedule('sch-1', 'pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('deleteFeedingSchedule should return data on success', () async {
      fakeRepository.setupDelete((id) async => Right<Failure, Map<String, dynamic>>({'message': 'Success'}));
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([]));

      await mutationNotifier.deleteFeedingSchedule('sch-1');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('deleteFeedingSchedule should refresh list after success', () async {
      var listRefreshed = false;
      fakeRepository.setupDelete((id) async => Right<Failure, Map<String, dynamic>>({'message': 'Success'}));
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<Schedule>>([]);
      });

      await mutationNotifier.deleteFeedingSchedule('sch-1');

      expect(listRefreshed, true);
    });

    test('deleteFeedingSchedule should emit error state on network failure', () async {
      fakeRepository.setupDelete((id) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')));

      await mutationNotifier.deleteFeedingSchedule('sch-1');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
