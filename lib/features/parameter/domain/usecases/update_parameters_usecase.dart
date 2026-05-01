import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/repositories/parameter_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateParametersUsecase {
  final ParameterRepository repository;

  UpdateParametersUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) {
    return repository.updateParameters(
      temperatureMax,
      temperatureNormal,
      temperatureMin,
      acidityMax,
      acidityNormal,
      acidityMin,
    );
  }
}
