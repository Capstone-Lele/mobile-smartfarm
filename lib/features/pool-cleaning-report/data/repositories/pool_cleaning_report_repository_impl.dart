import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/data/datasources/pool_cleaning_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/data/models/pool_cleaning_report_model.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/repositories/pool_cleaning_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class PoolCleaningReportRepositoryImpl implements PoolCleaningReportRepository {
  final PoolCleaningReportDatasource datasource;

  PoolCleaningReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<PoolCleaningReport>>> getPoolCleaningReports(
    String poolId,
  ) async {
    final result = await datasource.getPoolCleaningReports(poolId);

    return result.fold((failure) => Left(failure), (data) {
      final poolCleaningReports = data
          .map((json) => PoolCleaningReportModel.fromJson(json))
          .toList();
      return Right(poolCleaningReports);
    });
  }

  @override
  Future<Either<Failure, PoolCleaningReport>> getPoolCleaningReport(
    String id,
  ) async {
    final result = await datasource.getPoolCleaningReport(id);

    return result.fold((failure) => Left(failure), (data) {
      final poolCleaningReport = PoolCleaningReportModel.fromJson(data);
      return Right(poolCleaningReport);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createPoolCleaningReport(
    String poolId,
    String reportDate,
    XFile image,
  ) async {
    final result = await datasource.createPoolCleaningReport(
      poolId,
      reportDate,
      image,
    );

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePoolCleaningReport(
    String id,
    String reportDate,
    XFile? image,
  ) async {
    final result = await datasource.updatePoolCleaningReport(
      id,
      reportDate,
      image,
    );

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deletePoolCleaningReport(
    String id,
  ) async {
    final result = await datasource.deletePoolCleaningReport(id);

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }
}
