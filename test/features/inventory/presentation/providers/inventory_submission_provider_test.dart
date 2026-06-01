import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_submission_repository.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/create_inventory_submission_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/delete_inventory_submission_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/get_inventory_submission_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/get_inventory_submissions_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-submission/update_inventory_submission_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_submission_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeInventorySubmissionRepository implements InventorySubmissionRepository {
  Future<Either<Failure, List<InventorySubmission>>> Function()? _getListCallback;
  Future<Either<Failure, InventorySubmissionDetail>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String, int, String, String?)? _createCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String, String, int, String, String?)? _updateCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String)? _deleteCallback;

  void setupGetList(Future<Either<Failure, List<InventorySubmission>>> Function() callback) =>
      _getListCallback = callback;
  void setupGet(Future<Either<Failure, InventorySubmissionDetail>> Function(String) callback) =>
      _getCallback = callback;
  void setupCreate(Future<Either<Failure, Map<String, dynamic>>> Function(String, int, String, String?) callback) =>
      _createCallback = callback;
  void setupUpdate(Future<Either<Failure, Map<String, dynamic>>> Function(String, String, int, String, String?) callback) =>
      _updateCallback = callback;
  void setupDelete(Future<Either<Failure, Map<String, dynamic>>> Function(String) callback) =>
      _deleteCallback = callback;

  @override
  Future<Either<Failure, List<InventorySubmission>>> getInventorySubmissions() {
    if (_getListCallback != null) return _getListCallback!();
    return Future.value(Right<Failure, List<InventorySubmission>>([]));
  }

  @override
  Future<Either<Failure, InventorySubmissionDetail>> getInventorySubmission(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createInventorySubmission(
    String inventoryId, int quantity, String transactionType, String? notes,
  ) {
    if (_createCallback != null) return _createCallback!(inventoryId, quantity, transactionType, notes);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateInventorySubmission(
    String id, String inventoryId, int quantity, String transactionType, String? notes,
  ) {
    if (_updateCallback != null) return _updateCallback!(id, inventoryId, quantity, transactionType, notes);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteInventorySubmission(String id) {
    if (_deleteCallback != null) return _deleteCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

InventorySubmission _makeSubmission({String id = 'sub-1'}) => InventorySubmission(
  id: id,
  userId: 'user-1',
  user: 'John Doe',
  inventoryId: 'inv-1',
  product: 'Pakan Lele',
  category: 'Pakan',
  quantity: 50,
  unit: 'kg',
  status: 'pending',
  notes: 'Butuh tambahan pakan',
  createdAt: '2024-09-01T00:00:00.000Z',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
);

InventorySubmissionDetail _makeDetail() => InventorySubmissionDetail(
  id: 'sub-1',
  userId: 'user-1',
  user: 'John Doe',
  inventoryId: 'inv-1',
  product: 'Pakan Lele',
  category: 'Pakan',
  quantity: 50,
  unit: 'kg',
  status: 'pending',
  feedback: null,
  notes: 'Butuh tambahan pakan',
  createdAt: '2024-09-01T00:00:00.000Z',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeInventorySubmissionRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeInventorySubmissionRepository();
  });

  group('InventorySubmissionListNotifier', () {
    late InventorySubmissionListNotifier notifier;

    setUp(() {
      notifier = InventorySubmissionListNotifier(GetInventorySubmissionsUsecase(fakeRepository));
    });

    test('getInventorySubmissions should return data on success', () async {
      fakeRepository.setupGetList(
        () async => Right<Failure, List<InventorySubmission>>([_makeSubmission()]),
      );

      await notifier.getInventorySubmissions();

      expect(notifier.state, isA<AsyncData<List<InventorySubmission>>>());
      expect(notifier.state.value!.length, 1);
      expect(notifier.state.value!.first.product, 'Pakan Lele');
    });

    test('inventorySubmissionListNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getInventorySubmissionsUseCaseProvider.overrideWithValue(
            GetInventorySubmissionsUsecase(fakeRepository),
          ),
        ],
      );
      final state = container.read(inventorySubmissionListNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getInventorySubmissions should emit error state on network failure', () async {
      fakeRepository.setupGetList(
        () async => Left<Failure, List<InventorySubmission>>(FetchFailure('Network error')),
      );

      await notifier.getInventorySubmissions();

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('InventorySubmissionDetailNotifier', () {
    late InventorySubmissionDetailNotifier notifier;

    setUp(() {
      notifier = InventorySubmissionDetailNotifier(GetInventorySubmissionUsecase(fakeRepository));
    });

    test('getInventorySubmission should return detail on success', () async {
      fakeRepository.setupGet(
        (id) async => Right<Failure, InventorySubmissionDetail>(_makeDetail()),
      );

      await notifier.getInventorySubmission('sub-1');

      expect(notifier.state, isA<AsyncData<InventorySubmissionDetail?>>());
      expect(notifier.state.value!.id, 'sub-1');
    });

    test('inventorySubmissionDetailNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getInventorySubmissionUseCaseProvider.overrideWithValue(
            GetInventorySubmissionUsecase(fakeRepository),
          ),
        ],
      );
      final state = container.read(inventorySubmissionDetailNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getInventorySubmission should emit error state on network failure', () async {
      fakeRepository.setupGet(
        (id) async => Left<Failure, InventorySubmissionDetail>(FetchFailure('Network error')),
      );

      await notifier.getInventorySubmission('sub-1');

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('InventorySubmissionMutationNotifier', () {
    late InventorySubmissionListNotifier listNotifier;
    late InventorySubmissionDetailNotifier detailNotifier;
    late InventorySubmissionMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = InventorySubmissionListNotifier(GetInventorySubmissionsUsecase(fakeRepository));
      detailNotifier = InventorySubmissionDetailNotifier(GetInventorySubmissionUsecase(fakeRepository));
      mutationNotifier = InventorySubmissionMutationNotifier(
        CreateInventorySubmissionUsecase(fakeRepository),
        UpdateInventorySubmissionUsecase(fakeRepository),
        DeleteInventorySubmissionUsecase(fakeRepository),
        listNotifier,
        detailNotifier,
      );
    });

    test('createInventorySubmission should return data on success', () async {
      fakeRepository.setupCreate(
        (invId, qty, type, notes) async => Right<Failure, Map<String, dynamic>>({'success': true}),
      );
      fakeRepository.setupGetList(() async => Right<Failure, List<InventorySubmission>>([]));

      await mutationNotifier.createInventorySubmission('inv-1', 50, 'in', 'Notes');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createInventorySubmission should refresh list after success', () async {
      var listRefreshed = false;
      fakeRepository.setupCreate(
        (invId, qty, type, notes) async => Right<Failure, Map<String, dynamic>>({'success': true}),
      );
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<InventorySubmission>>([]);
      });

      await mutationNotifier.createInventorySubmission('inv-1', 50, 'in', 'Notes');

      expect(listRefreshed, true);
    });

    test('createInventorySubmission should emit error state on network failure', () async {
      fakeRepository.setupCreate(
        (invId, qty, type, notes) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')),
      );

      await mutationNotifier.createInventorySubmission('inv-1', 50, 'in', 'Notes');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('updateInventorySubmission should return data on success', () async {
      fakeRepository.setupUpdate(
        (id, invId, qty, type, notes) async => Right<Failure, Map<String, dynamic>>({'success': true}),
      );
      fakeRepository.setupGetList(() async => Right<Failure, List<InventorySubmission>>([]));
      fakeRepository.setupGet((id) async => Right<Failure, InventorySubmissionDetail>(_makeDetail()));

      await mutationNotifier.updateInventorySubmission('sub-1', 'inv-1', 50, 'in', 'Notes');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('updateInventorySubmission should refresh list and detail after success', () async {
      var listRefreshed = false;
      var detailRefreshed = false;
      fakeRepository.setupUpdate(
        (id, invId, qty, type, notes) async => Right<Failure, Map<String, dynamic>>({'success': true}),
      );
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<InventorySubmission>>([]);
      });
      fakeRepository.setupGet((id) async {
        detailRefreshed = true;
        return Right<Failure, InventorySubmissionDetail>(_makeDetail());
      });

      await mutationNotifier.updateInventorySubmission('sub-1', 'inv-1', 50, 'in', 'Notes');

      expect(listRefreshed, true);
      expect(detailRefreshed, true);
    });

    test('updateInventorySubmission should emit error state on network failure', () async {
      fakeRepository.setupUpdate(
        (id, invId, qty, type, notes) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')),
      );

      await mutationNotifier.updateInventorySubmission('sub-1', 'inv-1', 50, 'in', 'Notes');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('deleteInventorySubmission should return data on success', () async {
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({'success': true}),
      );
      fakeRepository.setupGetList(() async => Right<Failure, List<InventorySubmission>>([]));

      await mutationNotifier.deleteInventorySubmission('sub-1');

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('deleteInventorySubmission should refresh list after success', () async {
      var listRefreshed = false;
      fakeRepository.setupDelete(
        (id) async => Right<Failure, Map<String, dynamic>>({'success': true}),
      );
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<InventorySubmission>>([]);
      });

      await mutationNotifier.deleteInventorySubmission('sub-1');

      expect(listRefreshed, true);
    });

    test('deleteInventorySubmission should emit error state on network failure', () async {
      fakeRepository.setupDelete(
        (id) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')),
      );

      await mutationNotifier.deleteInventorySubmission('sub-1');

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
