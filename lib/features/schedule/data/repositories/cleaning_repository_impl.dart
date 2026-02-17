import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/datasources/cleaning_datasource.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/models/schedule_model.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/cleaning_repository.dart';
import 'package:dartz/dartz.dart';

class CleaningRepositoryImpl implements CleaningRepository {
  final CleaningDatasource datasource;

  CleaningRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Schedule>>> getCleaningSchedules() async {
    final result = await datasource.getCleaningSchedules();

    return result.fold((failure) => Left(failure), (data) {
      final schedules = data
          .map((json) => ScheduleModel.fromJson(json))
          .toList();
      return Right(schedules);
    });
  }

  @override
  Future<Either<Failure, Schedule>> getCleaningSchedule(String id) async {
    final result = await datasource.getCleaningSchedule(id);

    return result.fold((failure) => Left(failure), (data) {
      final schedule = ScheduleModel.fromJson(data);
      return Right(schedule);
    });
  }

  @override
  Future<Either<Failure, Schedule>> createCleaningSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    final result = await datasource.createCleaningSchedule(
      poolId,
      userId,
      scheduleDate,
    );

    return result.fold((failure) => Left(failure), (data) {
      final schedule = ScheduleModel.fromJson(data);
      return Right(schedule);
    });
  }

  @override
  Future<Either<Failure, Schedule>> updateCleaningSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    final result = await datasource.updateCleaningSchedule(
      id,
      poolId,
      userId,
      scheduleDate,
    );

    return result.fold((failure) => Left(failure), (data) {
      final schedule = ScheduleModel.fromJson(data);
      return Right(schedule);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteCleaningSchedule(
    String id,
  ) async {
    final result = await datasource.deleteCleaningSchedule(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
