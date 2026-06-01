import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/sampling_repository.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/create_sampling_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/delete_sampling_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/get_sampling_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/get_samplings_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/usecases/sampling/update_sampling_usecase.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/sampling_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSamplingRepository implements SamplingRepository {
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
  Future<Either<Failure, List<Schedule>>> getSamplingSchedules() {
    if (_getListCallback != null) return _getListCallback!();
    return Future.value(Right<Failure, List<Schedule>>([]));
  }

  @override
  Future<Either<Failure, Schedule>> getSamplingSchedule(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSamplingSchedule(String poolId, String userId, String scheduleDate) {
    if (_createCallback != null) return _createCallback!(poolId, userId, scheduleDate);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateSamplingSchedule(String id, String poolId, String userId, String scheduleDate) {
    if (_updateCallback != null) return _updateCallback!(id, poolId, userId, scheduleDate);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteSamplingSchedule(String id) {
    if (_deleteCallback != null) return _deleteCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

Schedule _makeSchedule({String id = 'sch-1', String? date}) => Schedule(
  id: id,
  poolName: 'Kolam A',
  userName: 'John Doe',
  scheduleDate: date ?? '2024-09-01T00:00:00.000Z',
  type: 'sampling',
  createdAt: '2024-09-01T00:00:00.000Z',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeSamplingRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeSamplingRepository();
  });

  group('SamplingListNotifier', () {
    late SamplingListNotifier notifier;

    setUp(() {
      notifier = SamplingListNotifier(GetSamplingsUsecase(fakeRepository));
    });

    test('getSamplingSchedules should return data on success', () async {
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([_makeSchedule()]));

      await notifier.getSamplingSchedules();

      expect(notifier.state, isA<AsyncData<List<Schedule>>>());
      expect(notifier.state.value!.length, 1);
    });

    test('samplingListNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getSamplingsUseCaseProvider.overrideWithValue(GetSamplingsUsecase(fakeRepository)),
        ],
      );
      final state = container.read(samplingListNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getSamplingSchedules should emit error state on network failure', () async {
      fakeRepository.setupGetList(() async => Left<Failure, List<Schedule>>(FetchFailure('Network error')));

      await notifier.getSamplingSchedules();

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('SamplingDetailNotifier', () {
    late SamplingDetailNotifier notifier;

    setUp(() {
      notifier = SamplingDetailNotifier(GetSamplingUsecase(fakeRepository));
    });

    test('getSamplingSchedule should return detail on success', () async {
      fakeRepository.setupGet((id) async => Right<Failure, Schedule>(_makeSchedule()));

      await notifier.getSamplingSchedule('sch-1');

      expect(notifier.state, isA<AsyncData<Schedule?>>());
      expect(notifier.state.value!.id, 'sch-1');
    });

    test('samplingDetailNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getSamplingUseCaseProvider.overrideWithValue(GetSamplingUsecase(fakeRepository)),
        ],
      );
      final state = container.read(samplingDetailNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getSamplingSchedule should emit error state on network failure', () async {
      fakeRepository.setupGet((id) async => Left<Failure, Schedule>(FetchFailure('Network error')));

      await notifier.getSamplingSchedule('sch-1');

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('SamplingMutationNotifier', () {
    late SamplingListNotifier listNotifier;
    late SamplingDetailNotifier detailNotifier;
    late SamplingMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = SamplingListNotifier(GetSamplingsUsecase(fakeRepository));
      detailNotifier = SamplingDetailNotifier(GetSamplingUsecase(fakeRepository));
      mutationNotifier = SamplingMutationNotifier(
        CreateSamplingUsecase(fakeRepository),
        UpdateSamplingUsecase(fakeRepository),
        DeleteSamplingUsecase(fakeRepository),
        listNotifier,
        detailNotifier,
      );
    });

    test('createSamplingSchedule should return data on success', () async {
      fakeRepository.setupCreate((poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-new'}));
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([]));

      await mutationNotifier.createSamplingSchedule('pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createSamplingSchedule should refresh list after success', () async {
      var listRefreshed = false;
      fakeRepository.setupCreate((poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-new'}));
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<Schedule>>([]);
      });

      await mutationNotifier.createSamplingSchedule('pool-1', 'user-1', '2024-09-01');

      expect(listRefreshed, true);
    });

    test('createSamplingSchedule should emit error state on network failure', () async {
      fakeRepository.setupCreate((poolId, userId, date) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')));

      await mutationNotifier.createSamplingSchedule('pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('updateSamplingSchedule should return data on success', () async {
      fakeRepository.setupUpdate((id, poolId, userId, date) async => Right<Failure, Map<String, dynamic>>({'id': 'sch-1'}));
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([]));
      fakeRepository.setupGet((id) async => Right<Failure, Schedule>(_makeSchedule()));

      await mutationNotifier.updateSamplingSchedule('sch-1', 'pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('updateSamplingSchedule should refresh list and detail after success', () async {
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

      await mutationNotifier.updateSamplingSchedule('sch-1', 'pool-1', 'user-1', '2024-09-01');

      expect(listRefreshed, true);
      expect(detailRefreshed, true);
    });

    test('updateSamplingSchedule should emit error state on network failure', () async {
      fakeRepository.setupUpdate((id, poolId, userId, date) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')));

      await mutationNotifier.updateSamplingSchedule('sch-1', 'pool-1', 'user-1', '2024-09-01');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('deleteSamplingSchedule should return data on success', () async {
      fakeRepository.setupDelete((id) async => Right<Failure, Map<String, dynamic>>({'message': 'Success'}));
      fakeRepository.setupGetList(() async => Right<Failure, List<Schedule>>([]));

      await mutationNotifier.deleteSamplingSchedule('sch-1');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('deleteSamplingSchedule should refresh list after success', () async {
      var listRefreshed = false;
      fakeRepository.setupDelete((id) async => Right<Failure, Map<String, dynamic>>({'message': 'Success'}));
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<Schedule>>([]);
      });

      await mutationNotifier.deleteSamplingSchedule('sch-1');

      expect(listRefreshed, true);
    });

    test('deleteSamplingSchedule should emit error state on network failure', () async {
      fakeRepository.setupDelete((id) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')));

      await mutationNotifier.deleteSamplingSchedule('sch-1');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
