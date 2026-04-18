import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/parameter/data/datasources/parameter_datasource.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/repositories/parameter_repository.dart';
import 'package:dartz/dartz.dart';

class ParameterRepositoryImpl implements ParameterRepository {
  final ParameterDatasource datasource;

  ParameterRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateParameter(
    String poolId,
    String temperatureMax,
    String temperatureMin,
    String acidityMax,
    String acidityMin,
  ) async {
    final result = await datasource.updateParameter(
      poolId,
      temperatureMax,
      temperatureMin,
      acidityMax,
      acidityMin,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
