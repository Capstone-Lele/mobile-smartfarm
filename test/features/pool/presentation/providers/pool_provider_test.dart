import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/usecases/get_pool_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/usecases/get_pools_usecase.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePoolRepository implements PoolRepository {
  Future<Either<Failure, List<Pool>>> Function()? _getPoolsCallback;
  Future<Either<Failure, PoolDetail>> Function(String)? _getPoolCallback;

  void setupGetPools(
    Future<Either<Failure, List<Pool>>> Function() callback,
  ) => _getPoolsCallback = callback;

  void setupGetPool(
    Future<Either<Failure, PoolDetail>> Function(String) callback,
  ) => _getPoolCallback = callback;

  @override
  Future<Either<Failure, List<Pool>>> getPools() {
    if (_getPoolsCallback != null) return _getPoolsCallback!();
    return Future.value(Right<Failure, List<Pool>>([]));
  }

  @override
  Future<Either<Failure, PoolDetail>> getPool(String id) {
    if (_getPoolCallback != null) return _getPoolCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

Pool _makePool({String id = 'pool-1'}) => Pool(
  cycleId: 'cycle-1',
  cycle: 'active_cultivation',
  cycleStartDate: '2024-01-01',
  cycleEndDate: null,
  currentQuantity: 1000,
  image: 'https://example.com/image.jpg',
  mortality: 50,
  movedQuantity: 0,
  id: id,
  name: 'Kolam A',
  category: 'growing',
  diameter: '5',
  length: null,
  width: null,
  height: '1.2',
  temperatureMax: const [30.0],
  temperatureNormal: const [28.0],
  temperatureMin: const [25.0],
  acidityMax: const [7.5],
  acidityNormal: const [7.0],
  acidityMin: const [6.5],
  createdAt: '2024-01-01T00:00:00.000Z',
  updatedAt: '2024-01-01T00:00:00.000Z',
  deletedAt: null,
);

PoolDetail _makeDetail({String id = 'pool-1'}) => PoolDetail(
  cycleId: 'cycle-1',
  cycle: 'active_cultivation',
  currentQuantity: 1000,
  image: 'https://example.com/image.jpg',
  id: id,
  name: 'Kolam A',
  category: 'growing',
  diameter: '5',
  length: null,
  width: null,
  height: '1.2',
  temperatureMax: const [30.0],
  temperatureNormal: const [28.0],
  temperatureMin: const [25.0],
  acidityMax: const [7.5],
  acidityNormal: const [7.0],
  acidityMin: const [6.5],
  createdAt: '2024-01-01T00:00:00.000Z',
  updatedAt: '2024-01-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakePoolRepository fakeRepository;

  setUp(() {
    fakeRepository = FakePoolRepository();
  });

  group('PoolListNotifier', () {
    late PoolListNotifier notifier;

    setUp(() {
      notifier = PoolListNotifier(
        GetPoolsUsecase(fakeRepository),
      );
    });

    test('getPools should return data on success', () async {
      // Arrange
      fakeRepository.setupGetPools(
        () async => Right<Failure, List<Pool>>([_makePool()]),
      );

      // Act
      await notifier.getPools();

      // Assert
      expect(notifier.state, isA<AsyncData<List<Pool>>>());
      final data = (notifier.state as AsyncData<List<Pool>>).value;
      expect(data.length, 1);
      expect(data.first.id, 'pool-1');
      expect(data.first.name, 'Kolam A');
      expect(data.first.category, 'growing');
    });

    test(
      'poolListNotifierProvider should be initialized with AsyncData([])',
      () {
        final container = ProviderContainer(
          overrides: [
            getPoolsUseCaseProvider.overrideWithValue(
              GetPoolsUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(poolListNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, isEmpty);
      },
    );

    test(
      'getPools should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetPools(
          () async => Left<Failure, List<Pool>>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getPools();

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });

  group('PoolDetailNotifier', () {
    late PoolDetailNotifier notifier;

    setUp(() {
      notifier = PoolDetailNotifier(
        GetPoolUsecase(fakeRepository),
      );
    });

    test('getPool should return detail on success', () async {
      // Arrange
      fakeRepository.setupGetPool(
        (id) async => Right<Failure, PoolDetail>(_makeDetail()),
      );

      // Act
      await notifier.getPool('pool-1');

      // Assert
      expect(notifier.state, isA<AsyncData<PoolDetail?>>());
      final detail = (notifier.state as AsyncData<PoolDetail?>).value;
      expect(detail, isNotNull);
      expect(detail!.id, 'pool-1');
      expect(detail.name, 'Kolam A');
      expect(detail.category, 'growing');
    });

    test(
      'poolDetailNotifierProvider should be initialized with AsyncData(null)',
      () {
        final container = ProviderContainer(
          overrides: [
            getPoolUseCaseProvider.overrideWithValue(
              GetPoolUsecase(fakeRepository),
            ),
          ],
        );

        final state = container.read(poolDetailNotifierProvider);

        expect(state.hasValue, true);
        expect(state.value, null);
      },
    );

    test(
      'getPool should emit error state on network failure',
      () async {
        // Arrange
        fakeRepository.setupGetPool(
          (id) async => Left<Failure, PoolDetail>(
            FetchFailure('Network error'),
          ),
        );

        // Act
        await notifier.getPool('pool-1');

        // Assert
        expect(notifier.state, isA<AsyncError>());
        final error = (notifier.state as AsyncError).error;
        expect(error.toString(), contains('Network error'));
      },
    );
  });
}
