import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:dartz/dartz.dart';

class GetIotsUsecase {
  final IotRepository repository;

  GetIotsUsecase(this.repository);

  Future<Either<Failure, List<Iot>>> execute() {
    return repository.getIots();
  }
}
