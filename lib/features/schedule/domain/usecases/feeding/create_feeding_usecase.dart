import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/feeding_repository.dart';
import 'package:dartz/dartz.dart';

class CreateFeedingUsecase {
  final FeedingRepository repository;

  CreateFeedingUsecase(this.repository);

  Future<Either<Failure, Schedule>> execute(
    String poolId,
    String userId,
    String scheduleDate,
  ) {
    return repository.createFeedingSchedule(poolId, userId, scheduleDate);
  }
}
