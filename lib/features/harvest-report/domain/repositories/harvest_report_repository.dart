import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class HarvestReportRepository {
  Future<Either<Failure, List<HarvestReport>>> getHarvestReports(String poolId);
  Future<Either<Failure, HarvestReport>> getHarvestReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createHarvestReport(
    String cycleId,
    String reportDate,
    int amount,
    XFile image,
  );
}
