import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/cleaning_repository.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/create_cleaning_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/delete_cleaning_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/get_cleaning_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/get_cleanings_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/cleaning/update_cleaning_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/cleaning_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCleaningRepository implements CleaningRepository {
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
  Future<Either<Failure, List<Schedule>>> getCleaningSchedules() {
    if (_getListCallback != null) return _getListCallback!();
    return Future.value(Right<Failure, List<Schedule>>([]));
  }

  @override
  Future<Either<Failure, Schedule>> getCleaningSchedule(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createCleaningSchedule(String poolId, String userId, String scheduleDate) {
    if (_createCallback != null) return _createCallback!(poolId, userId, scheduleDate);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateCleaningSchedule(String id, String poolId, String userId, String scheduleDate) {
    if (_updateCallback != null) return _updateCallback!(id, poolId, userId, scheduleDate);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteCleaningSchedule(String id) {
    if (_deleteCallback != null) return _deleteCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

Schedule _makeSchedule({String id = 'sch-1', String? date}) => Schedule(
  id: id,
  poolName: 'Kolam A',
  userName: 'John Doe',
  scheduleDate: date ?? '2024-09-01T00:00:00.000Z',
  type: 'cleaning',
  createdAt: '2024-09-01T00:00:00.000Z',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeCleaningRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeCleaningRepository();
  });

  group('CleaningListNotifier', () {
    late CleaningListNotifier notifier;

    setUp(() {
      notifier = CleaningListNotifier(GetCleaningsUsecase(fakeRepository));
    });

    test('getCleaningSchedules should return data on success', () async {
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([_makeSchedule()]));

      await notifier.getCleaningSchedules();

      expect(notifier.state, isA<AsyncData<List<Schedule>>>());
      expect(notifier.state.value!.length, 1);
    });

    test('cleaningListNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getCleaningsUseCaseProvider.overrideWithValue(GetCleaningsUsecase(fakeRepository)),
        ],
      );
      final state = container.read(cleaningListNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getCleaningSchedules should emit error state on network failure', () async {
      fakeRepository.setupGetList(() async => Left<Failure, List<Schedule>>(FetchFailure('Network error')));

      await notifier.getCleaningSchedules();

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('CleaningDetailNotifier', () {
    late CleaningDetailNotifier notifier;

    setUp(() {
      notifier = CleaningDetailNotifier(GetCleaningUsecase(fakeRepository));
    });

    test('getCleaningSchedule should return detail on success', () async {
      fakeRepository.setupGet((id) async => Right<Failure, Schedule>(_makeSchedule()));

      await notifier.getCleaningSchedule('sch-1');

      expect(notifier.state, isA<AsyncData<Schedule?>>());
      expect(notifier.state.value!.id, 'sch-1');
    });

    test('cleaningDetailNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getCleaningUseCaseProvider.overrideWithValue(GetCleaningUsecase(fakeRepository)),
        ],
      );
      final state = container.read(cleaningDetailNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getCleaningSchedule should emit error state on network failure', () async {
      fakeRepository.setupGet((id) async => Left<Failure, Schedule>(FetchFailure('Network error')));

      await notifier.getCleaningSchedule('sch-1');

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('CleaningMutationNotifier', () {
    late CleaningListNotifier listNotifier;
    late CleaningDetailNotifier detailNotifier;
    late CleaningMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = CleaningListNotifier(GetCleaningsUsecase(fakeRepository));
      detailNotifier = CleaningDetailNotifier(GetCleaningUsecase(fakeRepository));
      mutationNotifier = CleaningMutationNotifier(
        CreateCleaningUsecase(fakeRepository),
        UpdateCleaningUsecase(fakeRepository),
        DeleteCleaningUsecase(fakeRepository),
        listNotifier,
        detailNotifier,
      );
    });

    test('createCleaningSchedule should return data on success', () async {
      fakeRepository.setupCreate((poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-new'}));
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([]));

      await mutationNotifier.createCleaningSchedule('pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createCleaningSchedule should refresh list after success', () async {
      var listRefreshed = false;
      fakeRepository.setupCreate((poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-new'}));
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<Schedule>>([]);
      });

      await mutationNotifier.createCleaningSchedule('pool-1', 'user-1', '2024-09-01');

      expect(listRefreshed, true);
    });

    test('createCleaningSchedule should emit error state on network failure', () async {
      fakeRepository.setupCreate((poolId, userId, date) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')));

      await mutationNotifier.createCleaningSchedule('pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('updateCleaningSchedule should return data on success', () async {
      fakeRepository.setupUpdate((id, poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-1'}));
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([]));
      fakeRepository.setupGet((id) async => Right<Failure, Schedule>(_makeSchedule()));

      await mutationNotifier.updateCleaningSchedule('sch-1', 'pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('updateCleaningSchedule should refresh list and detail after success', () async {
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

      await mutationNotifier.updateCleaningSchedule('sch-1', 'pool-1', 'user-1', '2024-09-01');

      expect(listRefreshed, true);
      expect(detailRefreshed, true);
    });

    test('updateCleaningSchedule should emit error state on network failure', () async {
      fakeRepository.setupUpdate((id, poolId, userId, date) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')));

      await mutationNotifier.updateCleaningSchedule('sch-1', 'pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('deleteCleaningSchedule should return data on success', () async {
      fakeRepository.setupDelete((id) async => Right<Failure, Map<String, dynamic>>({'message': 'Success'}));
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([]));

      await mutationNotifier.deleteCleaningSchedule('sch-1');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('deleteCleaningSchedule should refresh list after success', () async {
      var listRefreshed = false;
      fakeRepository.setupDelete((id) async => Right<Failure, Map<String, dynamic>>({'message': 'Success'}));
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<Schedule>>([]);
      });

      await mutationNotifier.deleteCleaningSchedule('sch-1');

      expect(listRefreshed, true);
    });

    test('deleteCleaningSchedule should emit error state on network failure', () async {
      fakeRepository.setupDelete((id) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')));

      await mutationNotifier.deleteCleaningSchedule('sch-1');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
