import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:dartz/dartz.dart';

abstract class FeedingRepository {
  Future<Either<Failure, List<Schedule>>> getFeedingSchedules();
  Future<Either<Failure, Schedule>> getFeedingSchedule(String id);
  Future<Either<Failure, Schedule>> createFeedingSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  );
  Future<Either<Failure, Schedule>> updateFeedingSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteFeedingSchedule(
    String id,
  );
}
