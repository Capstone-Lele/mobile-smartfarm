import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/repositories/parameter_repository.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/usecases/update_parameter_usecase.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/usecases/update_parameters_usecase.dart';
import 'package:budidaya_lele_mobile/features/parameter/presentation/providers/parameter_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeParameterRepository implements ParameterRepository {
  Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    List<double>,
    List<double>,
    List<double>,
    List<double>,
    List<double>,
    List<double>,
  )? _updateParameterCallback;

  Future<Either<Failure, Map<String, dynamic>>> Function(
    List<double>,
    List<double>,
    List<double>,
    List<double>,
    List<double>,
    List<double>,
  )? _updateParametersCallback;

  void setupUpdateParameter(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      List<double>,
      List<double>,
      List<double>,
      List<double>,
      List<double>,
      List<double>,
    )
    callback,
  ) => _updateParameterCallback = callback;

  void setupUpdateParameters(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      List<double>,
      List<double>,
      List<double>,
      List<double>,
      List<double>,
      List<double>,
    )
    callback,
  ) => _updateParametersCallback = callback;

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateParameter(
    String poolId,
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) {
    if (_updateParameterCallback != null) {
      return _updateParameterCallback!(
        poolId,
        temperatureMax,
        temperatureNormal,
        temperatureMin,
        acidityMax,
        acidityNormal,
        acidityMin,
      );
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateParameters(
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) {
    if (_updateParametersCallback != null) {
      return _updateParametersCallback!(
        temperatureMax,
        temperatureNormal,
        temperatureMin,
        acidityMax,
        acidityNormal,
        acidityMin,
      );
    }
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

const _tMax = [30.0];
const _tNormal = [28.0];
const _tMin = [25.0];
const _aMax = [7.5];
const _aNormal = [7.0];
const _aMin = [6.5];

void main() {
  late FakeParameterRepository fakeRepository;
  late ParameterMutationNotifier mutationNotifier;

  setUp(() {
    fakeRepository = FakeParameterRepository();
    mutationNotifier = ParameterMutationNotifier(
      UpdateParameterUsecase(fakeRepository),
      UpdateParametersUsecase(fakeRepository),
    );
  });

  group('ParameterMutationNotifier', () {
    test('updateParameter should return data on success', () async {
      // Arrange
      fakeRepository.setupUpdateParameter(
        (poolId, tMax, tNormal, tMin, aMax, aNormal, aMin) async =>
            Right<Failure, Map<String, dynamic>>({'message': 'Parameter berhasil diubah'}),
      );

      // Act
      await mutationNotifier.updateParameter('pool-1', _tMax, _tNormal, _tMin, _aMax, _aNormal, _aMin);

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('parameterMutationNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          updateParameterUseCaseProvider.overrideWithValue(
            UpdateParameterUsecase(fakeRepository),
          ),
          updateParametersUseCaseProvider.overrideWithValue(
            UpdateParametersUsecase(fakeRepository),
          ),
        ],
      );

      final state = container.read(parameterMutationNotifierProvider);

      expect(state.hasValue, true);
      expect(state is AsyncData, true);
    });

    test('updateParameter should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupUpdateParameter(
        (poolId, tMax, tNormal, tMin, aMax, aNormal, aMin) async =>
            Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')),
      );

      // Act
      await mutationNotifier.updateParameter('pool-1', _tMax, _tNormal, _tMin, _aMax, _aNormal, _aMin);

      // Assert
      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('updateParameters (global) should return data on success', () async {
      // Arrange
      fakeRepository.setupUpdateParameters(
        (tMax, tNormal, tMin, aMax, aNormal, aMin) async =>
            Right<Failure, Map<String, dynamic>>({'message': 'Parameter global berhasil diubah'}),
      );

      // Act
      await mutationNotifier.updateParameters(_tMax, _tNormal, _tMin, _aMax, _aNormal, _aMin);

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('updateParameters (global) should return data when updating multiple thresholds', () async {
      // Arrange
      final multiTMax = [30.0, 31.0];
      final multiTNormal = [28.0, 29.0];
      final multiTMin = [25.0, 26.0];
      final multiAMax = [7.5, 8.0];
      final multiANormal = [7.0, 7.2];
      final multiAMin = [6.5, 6.8];

      fakeRepository.setupUpdateParameters(
        (tMax, tNormal, tMin, aMax, aNormal, aMin) async =>
            Right<Failure, Map<String, dynamic>>({'message': 'Parameter global berhasil diubah'}),
      );

      // Act
      await mutationNotifier.updateParameters(multiTMax, multiTNormal, multiTMin, multiAMax, multiANormal, multiAMin);

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('updateParameters (global) should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupUpdateParameters(
        (tMax, tNormal, tMin, aMax, aNormal, aMin) async =>
            Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')),
      );

      // Act
      await mutationNotifier.updateParameters(_tMax, _tNormal, _tMin, _aMax, _aNormal, _aMin);

      // Assert
      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
