import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:dartz/dartz.dart';

abstract class CleaningRepository {
  Future<Either<Failure, List<Schedule>>> getCleaningSchedules();
  Future<Either<Failure, Schedule>> getCleaningSchedule(String id);
  Future<Either<Failure, Map<String, dynamic>>> createCleaningSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  );
  Future<Either<Failure, Map<String, dynamic>>> updateCleaningSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteCleaningSchedule(
    String id,
  );
}
