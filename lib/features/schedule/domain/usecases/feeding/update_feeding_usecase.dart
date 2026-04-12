import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/feeding_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateFeedingUsecase {
  final FeedingRepository repository;

  UpdateFeedingUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  ) {
    return repository.updateFeedingSchedule(id, poolId, userId, scheduleDate);
  }
}
