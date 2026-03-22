import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class SickReportRepository {
  Future<Either<Failure, List<SickReport>>> getSickReports();
  Future<Either<Failure, SickReport>> getSickReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createSickReport(
    String originCycleId,
    String destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteSickReport(String id);
}
