import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/parameter/data/datasources/parameter_datasource.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/repositories/parameter_repository.dart';
import 'package:dartz/dartz.dart';

class ParameterRepositoryImpl implements ParameterRepository {
  final ParameterDatasource datasource;

  ParameterRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateParameters(
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) async {
    final result = await datasource.updateParameters(
      temperatureMax,
      temperatureNormal,
      temperatureMin,
      acidityMax,
      acidityNormal,
      acidityMin,
    );

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateParameter(
    String poolId,
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) async {
    final result = await datasource.updateParameter(
      poolId,
      temperatureMax,
      temperatureNormal,
      temperatureMin,
      acidityMax,
      acidityNormal,
      acidityMin,
    );

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }
}
