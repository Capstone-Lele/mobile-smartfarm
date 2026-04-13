import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class GetIotUsecase {
  final IotRepository repository;

  GetIotUsecase(this.repository);

  Future<Either<Failure, Iot>> execute(String nodeId) {
    return repository.getIot(nodeId);
  }
}
