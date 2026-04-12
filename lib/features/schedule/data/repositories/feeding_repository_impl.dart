import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/datasources/feeding_datasource.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/models/schedule_model.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/feeding_repository.dart';
import 'package:dartz/dartz.dart';

class FeedingRepositoryImpl implements FeedingRepository {
  final FeedingDatasource datasource;

  FeedingRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Schedule>>> getFeedingSchedules() async {
    final result = await datasource.getFeedingSchedules();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final schedules = data
            .map((json) => ScheduleModel.fromJson(json))
            .toList();
        return Right(schedules);
      } catch (e) {
        return Left(InvalidInputFailure('Gagal mengkonversi data jadwal pemberian makan: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, Schedule>> getFeedingSchedule(String id) async {
    final result = await datasource.getFeedingSchedule(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final schedule = ScheduleModel.fromJson(data);
        return Right(schedule);
      } catch (e) {
        return Left(InvalidInputFailure('Gagal mengkonversi data jadwal pemberian makan: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createFeedingSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    final result = await datasource.createFeedingSchedule(
      poolId,
      userId,
      scheduleDate,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateFeedingSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    final result = await datasource.updateFeedingSchedule(
      id,
      poolId,
      userId,
      scheduleDate,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteFeedingSchedule(
    String id,
  ) async {
    final result = await datasource.deleteFeedingSchedule(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
