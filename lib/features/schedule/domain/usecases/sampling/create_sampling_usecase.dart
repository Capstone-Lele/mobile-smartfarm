import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/sampling_repository.dart';
import 'package:dartz/dartz.dart';

class CreateSamplingUsecase {
  final SamplingRepository repository;

  CreateSamplingUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String poolId,
    String userId,
    String scheduleDate,
  ) {
    return repository.createSamplingSchedule(poolId, userId, scheduleDate);
  }
}
