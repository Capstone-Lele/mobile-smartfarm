import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class ParameterRepository {
  Future<Either<Failure, Map<String, dynamic>>> updateParameters(
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  );

  Future<Either<Failure, Map<String, dynamic>>> updateParameter(
    String poolId,
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  );
}
