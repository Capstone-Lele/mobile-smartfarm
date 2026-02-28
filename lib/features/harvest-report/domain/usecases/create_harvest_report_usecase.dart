import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/repositories/harvest_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreateHarvestReportUsecase {
  final HarvestReportRepository repository;

  CreateHarvestReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String cycleId,
    String reportDate,
    int amount,
    XFile image,
  ) {
    return repository.createHarvestReport(cycleId, reportDate, amount, image);
  }
}
