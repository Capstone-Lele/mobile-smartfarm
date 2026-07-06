import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/repositories/sick_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreateSickReportUsecase {
  final SickReportRepository repository;

  CreateSickReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String poolId,
    String originCycleId,
    String? destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
    String? endedAt,
  ) {
    return repository.createSickReport(
      poolId,
      originCycleId,
      destinationCycleId,
      reportDate,
      quantity,
      image,
      endedAt,
    );
  }
}
