import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/report/data/datasources/report_datasource.dart';
import 'package:budidaya_lele_mobile/features/report/data/models/activity_log_model.dart';
import 'package:budidaya_lele_mobile/features/report/data/models/total_report_model.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/activity_log.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/total_report.dart';
import 'package:budidaya_lele_mobile/features/report/domain/repositories/report_repository.dart';
import 'package:dartz/dartz.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDatasource datasource;

  ReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<ActivityLog>>> getActivityLogs() async {
    final result = await datasource.getActivityLogs();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final activityLogs =
            data.map((json) => ActivityLogModel.fromJson(json)).toList();
        return Right(activityLogs);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data catatan aktivitas: $e"),
        );
      }
    });
  }

  @override
  Future<Either<Failure, TotalReport>> getTotalReports(int month) async {
    final result = await datasource.getTotalReports(month);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final totalReports = TotalReportModel.fromJson(data);
        return Right(totalReports);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data laporan total: $e"),
        );
      }
    });
  }

  @override
  Future<Either<Failure, TotalReport>> getTotalReportsByPool(String poolId, int month) async {
    final result = await datasource.getTotalReportsByPool(poolId, month);

     return result.fold((failure) => Left(failure), (data) {
      try {
        final totalReports = TotalReportModel.fromJson(data);
        return Right(totalReports);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data laporan total: $e"),
        );
      }
    });
  }
}
