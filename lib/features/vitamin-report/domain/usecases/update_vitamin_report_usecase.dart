import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/repositories/vitamin_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class UpdateVitaminReportUsecase {
  final VitaminReportRepository repository;

  UpdateVitaminReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  ) {
    return repository.updateVitaminReport(
      id,
      inventoryId,
      reportDate,
      quantity,
      image,
    );
  }
}
