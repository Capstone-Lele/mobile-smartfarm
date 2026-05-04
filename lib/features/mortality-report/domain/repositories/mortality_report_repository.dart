import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class MortalityReportRepository {
  Future<Either<Failure, List<MortalityReport>>> getMortalityReports(
    String poolId,
  );
  Future<Either<Failure, MortalityReportDetail>> getMortalityReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createMortalityReport(
    String cycleId,
    String userId,
    String reportDate,
    int quantity,
    XFile image,
    String notes,
  );
  Future<Either<Failure, Map<String, dynamic>>> updateMortalityReport(
    String id,
    String reportDate,
    int quantity,
    XFile? image,
    String notes,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteMortalityReport(
    String id,
  );
}
