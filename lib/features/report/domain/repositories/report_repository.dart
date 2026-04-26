import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/activity_log.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/total_report.dart';
import 'package:dartz/dartz.dart';

abstract class ReportRepository {
  Future<Either<Failure, List<ActivityLog>>> getActivityLogs();
  Future<Either<Failure, TotalReport>> getTotalReports(int month);
  Future<Either<Failure, TotalReport>> getTotalReportsByPool(String poolId, int month);
}
