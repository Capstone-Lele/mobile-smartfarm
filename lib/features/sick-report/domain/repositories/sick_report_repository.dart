import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class SickReportRepository {
  Future<Either<Failure, List<SickReport>>> getSickReports(String poolId);
  Future<Either<Failure, SickReportDetail>> getSickReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createSickReport(
    String poolId,
    String originCycleId,
    String? destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
    String? endedAt,
  );
}
