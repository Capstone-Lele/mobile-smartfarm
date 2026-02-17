import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class VitaminReportRepository {
  Future<Either<Failure, List<VitaminReport>>> getVitaminReports();
  Future<Either<Failure, VitaminReport>> getVitaminReport(String id);
  Future<Either<Failure, VitaminReport>> createVitaminReport(
    String cycleId,
    String userId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  );
  Future<Either<Failure, VitaminReport>> updateVitaminReport(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile? image,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteVitaminReport(String id);
}
