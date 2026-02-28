import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class SamplingReportRepository {
  Future<Either<Failure, List<SamplingReport>>> getSamplingReports();
  Future<Either<Failure, SamplingReport>> getSamplingReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createSamplingReport(
    String cycleId,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile image,
  );
  Future<Either<Failure, Map<String, dynamic>>> updateSamplingReport(
    String id,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile? image,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteSamplingReport(
    String id,
  );
}
