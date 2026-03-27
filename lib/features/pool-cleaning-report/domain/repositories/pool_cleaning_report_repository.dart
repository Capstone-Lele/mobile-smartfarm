import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class PoolCleaningReportRepository {
  Future<Either<Failure, List<PoolCleaningReport>>> getPoolCleaningReports(String poolId);
  Future<Either<Failure, PoolCleaningReport>> getPoolCleaningReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createPoolCleaningReport(
    String poolId,
    String reportDate,
    XFile image,
  );
  Future<Either<Failure, Map<String, dynamic>>> updatePoolCleaningReport(
    String id,
    String reportDate,
    XFile? image,
  );
  Future<Either<Failure, Map<String, dynamic>>> deletePoolCleaningReport(
    String id,
  );
}
