import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:dartz/dartz.dart';

abstract class SamplingRepository {
  Future<Either<Failure, List<Schedule>>> getSamplingSchedules();
  Future<Either<Failure, Schedule>> getSamplingSchedule(String id);
  Future<Either<Failure, Schedule>> createSamplingSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  );
  Future<Either<Failure, Schedule>> updateSamplingSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteSamplingSchedule(
    String id,
  );
}
