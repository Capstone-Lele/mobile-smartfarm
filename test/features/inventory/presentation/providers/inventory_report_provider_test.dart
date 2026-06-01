import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_report_repository.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-report/create_inventory_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-report/get_inventory_report_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/inventory-report/get_inventory_reports_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_report_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeInventoryReportRepository implements InventoryReportRepository {
  Future<Either<Failure, List<InventoryReport>>> Function()? _getListCallback;
  Future<Either<Failure, InventoryReportDetail>> Function(String)? _getCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String, String, int, XFile, String?)? _createCallback;

  void setupGetList(Future<Either<Failure, List<InventoryReport>>> Function() callback) =>
      _getListCallback = callback;
  void setupGet(Future<Either<Failure, InventoryReportDetail>> Function(String) callback) =>
      _getCallback = callback;
  void setupCreate(Future<Either<Failure, Map<String, dynamic>>> Function(String, String, int, XFile, String?) callback) =>
      _createCallback = callback;

  @override
  Future<Either<Failure, List<InventoryReport>>> getInventoryReports() {
    if (_getListCallback != null) return _getListCallback!();
    return Future.value(Right<Failure, List<InventoryReport>>([]));
  }

  @override
  Future<Either<Failure, InventoryReportDetail>> getInventoryReport(String id) {
    if (_getCallback != null) return _getCallback!(id);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createInventoryReport(
    String inventoryId, String reportDate, int quantity, XFile image, String? notes,
  ) {
    if (_createCallback != null) return _createCallback!(inventoryId, reportDate, quantity, image, notes);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

InventoryReport _makeReport({String id = 'rep-1'}) => InventoryReport(
  id: id,
  user: 'John Doe',
  inventoryId: 'inv-1',
  product: 'Pakan Lele',
  reportDate: '2024-09-01',
  quantity: '20',
  unit: 'kg',
  image: 'https://example.com/img.jpg',
  notes: null,
  createdAt: '2024-09-01T00:00:00.000Z',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
);

InventoryReportDetail _makeDetail() => InventoryReportDetail(
  id: 'rep-1',
  userId: 'user-1',
  user: 'John Doe',
  product: 'Pakan Lele',
  inventoryId: 'inv-1',
  reportDate: '2024-09-01',
  quantity: '20',
  type: 'out',
  transactionType: null,
  image: 'https://example.com/img.jpg',
  notes: null,
  createdAt: '2024-09-01T00:00:00.000Z',
  updatedAt: '2024-09-01T00:00:00.000Z',
  deletedAt: null,
);

void main() {
  late FakeInventoryReportRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeInventoryReportRepository();
  });

  group('InventoryReportListNotifier', () {
    late InventoryReportListNotifier notifier;

    setUp(() {
      notifier = InventoryReportListNotifier(GetInventoryReportsUsecase(fakeRepository));
    });

    test('getInventoryReports should return data on success', () async {
      fakeRepository.setupGetList(
        () async => Right<Failure, List<InventoryReport>>([_makeReport()]),
      );

      await notifier.getInventoryReports();

      expect(notifier.state, isA<AsyncData<List<InventoryReport>>>());
      expect(notifier.state.value!.length, 1);
      expect(notifier.state.value!.first.product, 'Pakan Lele');
    });

    test('inventoryReportListNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getInventoryReportsUseCaseProvider.overrideWithValue(
            GetInventoryReportsUsecase(fakeRepository),
          ),
        ],
      );
      final state = container.read(inventoryReportListNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getInventoryReports should emit error state on network failure', () async {
      fakeRepository.setupGetList(
        () async => Left<Failure, List<InventoryReport>>(FetchFailure('Network error')),
      );

      await notifier.getInventoryReports();

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('InventoryReportDetailNotifier', () {
    late InventoryReportDetailNotifier notifier;

    setUp(() {
      notifier = InventoryReportDetailNotifier(GetInventoryReportUsecase(fakeRepository));
    });

    test('getInventoryReport should return detail on success', () async {
      fakeRepository.setupGet(
        (id) async => Right<Failure, InventoryReportDetail>(_makeDetail()),
      );

      await notifier.getInventoryReport('rep-1');

      expect(notifier.state, isA<AsyncData<InventoryReportDetail?>>());
      expect(notifier.state.value!.id, 'rep-1');
    });

    test('inventoryReportDetailNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getInventoryReportUseCaseProvider.overrideWithValue(
            GetInventoryReportUsecase(fakeRepository),
          ),
        ],
      );
      final state = container.read(inventoryReportDetailNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getInventoryReport should emit error state on network failure', () async {
      fakeRepository.setupGet(
        (id) async => Left<Failure, InventoryReportDetail>(FetchFailure('Network error')),
      );

      await notifier.getInventoryReport('rep-1');

      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('InventoryReportMutationNotifier', () {
    late InventoryReportListNotifier listNotifier;
    late InventoryReportMutationNotifier mutationNotifier;

    setUp(() {
      listNotifier = InventoryReportListNotifier(GetInventoryReportsUsecase(fakeRepository));
      mutationNotifier = InventoryReportMutationNotifier(
        CreateInventoryReportUsecase(fakeRepository),
        listNotifier,
      );
    });

    test('createInventoryReport should return data on success', () async {
      fakeRepository.setupCreate(
        (invId, date, qty, img, notes) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'rep-new'}),
      );
      fakeRepository.setupGetList(() async => Right<Failure, List<InventoryReport>>([]));

      await mutationNotifier.createInventoryReport('inv-1', '2024-09-01', 20, XFile('img.jpg'), null);

      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('createInventoryReport should refresh list after success', () async {
      var listRefreshed = false;
      fakeRepository.setupCreate(
        (invId, date, qty, img, notes) async =>
            Right<Failure, Map<String, dynamic>>({'id': 'rep-new'}),
      );
      fakeRepository.setupGetList(() async {
        listRefreshed = true;
        return Right<Failure, List<InventoryReport>>([]);
      });

      await mutationNotifier.createInventoryReport('inv-1', '2024-09-01', 20, XFile('img.jpg'), null);

      expect(listRefreshed, true);
    });

    test('createInventoryReport should emit error state on network failure', () async {
      fakeRepository.setupCreate(
        (invId, date, qty, img, notes) async =>
            Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')),
      );

      await mutationNotifier.createInventoryReport('inv-1', '2024-09-01', 20, XFile('img.jpg'), null);

      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
