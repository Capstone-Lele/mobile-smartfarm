import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/cleaning_repository.dart';
import 'package:dartz/dartz.dart';

class CreateCleaningUsecase {
  final CleaningRepository repository;

  CreateCleaningUsecase(this.repository);

  Future<Either<Failure, Schedule>> execute(
    String poolId,
    String userId,
    String scheduleDate,
  ) {
    return repository.createCleaningSchedule(poolId, userId, scheduleDate);
  }
}
