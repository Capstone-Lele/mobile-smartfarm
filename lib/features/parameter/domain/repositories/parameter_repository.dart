import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class ParameterRepository {
  Future<Either<Failure, Map<String, dynamic>>> updateParameter(
    String poolId,
    String temperatureMax,
    String temperatureMin,
    String acidityMax,
    String acidityMin,
  );
}
