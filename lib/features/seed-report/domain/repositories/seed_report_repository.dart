import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class SeedReportRepository {
  Future<Either<Failure, List<SeedReport>>> getSeedReports(String poolId);
  Future<Either<Failure, SeedReportDetail>> getSeedReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createSeedReport(
    String poolId,
    String userId,
    String reportDate,
    int initialQuantity,
    int currentQuantity,
    double initialAverageWeight,
    XFile image,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteSeedReport(String id);
}
