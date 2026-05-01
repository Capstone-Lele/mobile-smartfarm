import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/repositories/parameter_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateParameterUsecase {
  final ParameterRepository repository;

  UpdateParameterUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String poolId,
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) {
    return repository.updateParameter(
      poolId,
      temperatureMax,
      temperatureNormal,
      temperatureMin,
      acidityMax,
      acidityNormal,
      acidityMin,
    );
  }
}
