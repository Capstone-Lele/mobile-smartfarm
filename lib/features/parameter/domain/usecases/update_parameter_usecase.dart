import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/parameter/domain/repositories/parameter_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateParameterUsecase {
  final ParameterRepository repository;

  UpdateParameterUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String poolId,
    String temperatureMax,
    String temperatureMin,
    String acidityMax,
    String acidityMin,
  ) {
    return repository.updateParameter(
      poolId,
      temperatureMax,
      temperatureMin,
      acidityMax,
      acidityMin,
    );
  }
}
