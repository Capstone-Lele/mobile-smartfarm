import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/sampling_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteSamplingUsecase {
  final SamplingRepository repository;

  DeleteSamplingUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteSamplingSchedule(id);
  }
}
