import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/chart_iots.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/usecases/get_chart_iots_usecase.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/usecases/get_iot_usecase.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/usecases/get_iots_usecase.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/providers/iot_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeIotRepository implements IotRepository {
  Future<Either<Failure, List<Iot>>> Function()? _getIotsCallback;
  Future<Either<Failure, Iot>> Function(String)? _getIotCallback;
  Future<Either<Failure, List<ChartIots>>> Function(String, String, String)? _getChartIotsCallback;

  void setupGetIots(Future<Either<Failure, List<Iot>>> Function() callback) => _getIotsCallback = callback;
  void setupGetIot(Future<Either<Failure, Iot>> Function(String) callback) => _getIotCallback = callback;
  void setupGetChartIots(Future<Either<Failure, List<ChartIots>>> Function(String, String, String) callback) => _getChartIotsCallback = callback;

  @override
  Future<Either<Failure, List<Iot>>> getIots() {
    if (_getIotsCallback != null) return _getIotsCallback!();
    return Future.value(Right<Failure, List<Iot>>([]));
  }

  @override
  Future<Either<Failure, Iot>> getIot(String nodeId) {
    if (_getIotCallback != null) return _getIotCallback!(nodeId);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, List<ChartIots>>> getChartIots(String nodeId, String startDate, String endDate) {
    if (_getChartIotsCallback != null) return _getChartIotsCallback!(nodeId, startDate, endDate);
    return Future.value(Right<Failure, List<ChartIots>>([]));
  }
}

Iot _makeIot({int nodeId = 1}) => Iot(
  nodeId: nodeId,
  ph: 7.2,
  temp: 28.5,
  receivedAt: '2024-09-01T10:00:00.000Z',
);

ChartIots _makeChartIot({String nodeId = '1'}) => ChartIots(
  nodeId: nodeId,
  ph: 7.1,
  temp: 28.0,
  createdAt: '2024-09-01T10:00:00.000Z',
);

void main() {
  late FakeIotRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeIotRepository();
  });

  group('IotListNotifier', () {
    late IotListNotifier notifier;

    setUp(() {
      notifier = IotListNotifier(GetIotsUsecase(fakeRepository));
    });

    test('getIots should return data on success', () async {
      // Arrange
      fakeRepository.setupGetIots(
        () async => Right<Failure, List<Iot>>([_makeIot(), _makeIot(nodeId: 2)]),
      );

      // Act
      await notifier.getIots();

      // Assert
      expect(notifier.state, isA<AsyncData<List<Iot>>>());
      final data = (notifier.state as AsyncData<List<Iot>>).value;
      expect(data.length, 2);
      expect(data.first.nodeId, 1);
      expect(data.first.ph, 7.2);
    });

    test('iotListNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getIotsUseCaseProvider.overrideWithValue(GetIotsUsecase(fakeRepository)),
        ],
      );

      final state = container.read(iotListNotifierProvider);

      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getIots should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupGetIots(
        () async => Left<Failure, List<Iot>>(FetchFailure('Network error')),
      );

      // Act
      await notifier.getIots();

      // Assert
      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('IotDetailNotifier', () {
    late IotDetailNotifier notifier;

    setUp(() {
      notifier = IotDetailNotifier(GetIotUsecase(fakeRepository));
    });

    test('getIot should return detail on success', () async {
      // Arrange
      fakeRepository.setupGetIot(
        (nodeId) async => Right<Failure, Iot>(_makeIot()),
      );

      // Act
      await notifier.getIot('1');

      // Assert
      expect(notifier.state, isA<AsyncData<Iot?>>());
      final iot = (notifier.state as AsyncData<Iot?>).value;
      expect(iot, isNotNull);
      expect(iot!.nodeId, 1);
      expect(iot.temp, 28.5);
    });

    test('iotDetailNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getIotUseCaseProvider.overrideWithValue(GetIotUsecase(fakeRepository)),
        ],
      );

      final state = container.read(iotDetailNotifierProvider);

      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getIot should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupGetIot(
        (nodeId) async => Left<Failure, Iot>(FetchFailure('Network error')),
      );

      // Act
      await notifier.getIot('1');

      // Assert
      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });

  group('ChartIotsNotifier', () {
    late ChartIotsNotifier notifier;

    setUp(() {
      notifier = ChartIotsNotifier(GetChartIotsUsecase(fakeRepository));
    });

    test('getChartIots should return data on success', () async {
      // Arrange
      fakeRepository.setupGetChartIots(
        (nodeId, startDate, endDate) async => Right<Failure, List<ChartIots>>([
          _makeChartIot(),
          _makeChartIot(),
        ]),
      );

      // Act
      await notifier.getChartIots('1', '2024-09-01', '2024-09-07');

      // Assert
      expect(notifier.state, isA<AsyncData<List<ChartIots>>>());
      final data = (notifier.state as AsyncData<List<ChartIots>>).value;
      expect(data.length, 2);
      expect(data.first.nodeId, '1');
      expect(data.first.ph, 7.1);
    });

    test('chartIotsNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getChartIotsUseCaseProvider.overrideWithValue(
            GetChartIotsUsecase(fakeRepository),
          ),
        ],
      );

      final state = container.read(chartIotsNotifierProvider);

      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getChartIots should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupGetChartIots(
        (nodeId, startDate, endDate) async => Left<Failure, List<ChartIots>>(
          FetchFailure('Network error'),
        ),
      );

      // Act
      await notifier.getChartIots('1', '2024-09-01', '2024-09-07');

      // Assert
      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
