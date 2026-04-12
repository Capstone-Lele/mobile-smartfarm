import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/sampling_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateSamplingUsecase {
  final SamplingRepository repository;

  UpdateSamplingUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  ) {
    return repository.updateSamplingSchedule(id, poolId, userId, scheduleDate);
  }
}
