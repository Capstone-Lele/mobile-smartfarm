import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/datasources/sampling_datasource.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/models/schedule_model.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/sampling_repository.dart';
import 'package:dartz/dartz.dart';

class SamplingRepositoryImpl implements SamplingRepository {
  final SamplingDatasource datasource;

  SamplingRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Schedule>>> getSamplingSchedules() async {
    final result = await datasource.getSamplingSchedules();
    return result.fold((failure) => Left(failure), (data) {
     try{
       final schedules = data
          .map((json) => ScheduleModel.fromJson(json))
          .toList();
      return Right(schedules);
     }catch(e){
        return Left(InvalidInputFailure('Gagal mengkonversi data jadwal sampling: $e'));
     }
    });
  }

  @override
  Future<Either<Failure, Schedule>> getSamplingSchedule(String id) async {
    final result = await datasource.getSamplingSchedule(id);

    return result.fold((failure) => Left(failure), (data) {
      try{
        final schedule = ScheduleModel.fromJson(data);
        return Right(schedule);
      }catch(e){
        return Left(InvalidInputFailure('Gagal mengkonversi data jadwal sampling: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSamplingSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    final result = await datasource.createSamplingSchedule(
      poolId,
      userId,
      scheduleDate,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateSamplingSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    final result = await datasource.updateSamplingSchedule(
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
  Future<Either<Failure, Map<String, dynamic>>> deleteSamplingSchedule(
    String id,
  ) async {
    final result = await datasource.deleteSamplingSchedule(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
