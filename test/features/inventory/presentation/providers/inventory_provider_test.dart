import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory/get_inventories_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory/get_inventory_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeInventoryRepository implements InventoryRepository {
  Future<Either<Failure, List<Inventory>>> Function()? _getListCallback;
  Future<Either<Failure, InventoryDetail>> Function(String)? _getCallback;

  void setupGetList(Future<Either<Failure, List<Inventory>>> Function() callback) =>
      _getListCallback = callback;
  void setupGet(Future<Either<Failure, InventoryDetail>> Function(String) callback) =>
      _getCallback = callback;

  @override
  Future<Either<Failure, List<Inventory>>> getInventories() {
    if (_getListCallback != null) return _getListCallback!();
    return Future.value(Right<Failure, List<Inventory>>([]));
  }

  @override
  Future<Either<Failure, InventoryDetail>> getInventory(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

const Inventory _inventory = Inventory(
  id: 'inv-1',
  productId: 'prod-1',
  product: 'Pakan Lele',
  categoryId: 'cat-1',
  category: 'Pakan',
  unitId: 'unit-1',
  unit: 'kg',
  totalQuantity: '50',
  minQuantity: '10',
  createdAt: '2024-09-01T00:00:00.000Z',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
);

InventoryDetail _makeDetail() => InventoryDetail(
  id: 'inv-1',
  productId: 'prod-1',
  product: 'Pakan Lele',
  unitId: 'unit-1',
  unit: 'kg',
  totalQuantity: '50',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeInventoryRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeInventoryRepository();
  });

  group('InventoryListNotifier', () {
    late InventoryListNotifier notifier;

    setUp(() {
      notifier = InventoryListNotifier(GetInventoriesUsecase(fakeRepository));
    });

    test('getInventories should return data on success', () async {
      fakeRepository.setupGetList(
        () async => Right<Failure, List<Inventory>>([_inventory]),
      );

      await notifier.getInventories();

      expect(notifier.state, isA<AsyncData<List<Inventory>>>());
      expect(notifier.state.value!.length, 1);
      expect(notifier.state.value!.first.product, 'Pakan Lele');
    });

    test('inventoryListNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getInventoriesUseCaseProvider.overrideWithValue(
            GetInventoriesUsecase(fakeRepository),
          ),
        ],
      );
      final state = container.read(inventoryListNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getInventories should emit error state on network failure', () async {
      fakeRepository.setupGetList(
        () async => Left<Failure, List<Inventory>>(FetchFailure('Network error')),
      );

      await notifier.getInventories();

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('InventoryDetailNotifier', () {
    late InventoryDetailNotifier notifier;

    setUp(() {
      notifier = InventoryDetailNotifier(GetInventoryUsecase(fakeRepository));
    });

    test('getInventory should return detail on success', () async {
      fakeRepository.setupGet(
        (id) async => Right<Failure, InventoryDetail>(_makeDetail()),
      );

      await notifier.getInventory('inv-1');

      expect(notifier.state, isA<AsyncData<InventoryDetail?>>());
      expect(notifier.state.value!.id, 'inv-1');
      expect(notifier.state.value!.product, 'Pakan Lele');
    });

    test('inventoryDetailNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getInventoryUseCaseProvider.overrideWithValue(
            GetInventoryUsecase(fakeRepository),
          ),
        ],
      );
      final state = container.read(inventoryDetailNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getInventory should emit error state on network failure', () async {
      fakeRepository.setupGet(
        (id) async => Left<Failure, InventoryDetail>(FetchFailure('Network error')),
      );

      await notifier.getInventory('inv-1');

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
