import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/repositories/mortality_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreateMortalityReportUsecase {
  final MortalityReportRepository repository;

  CreateMortalityReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String cycleId,
    String userId,
    String reportDate,
    int quantity,
    XFile image,
    String notes,
  ) {
    return repository.createMortalityReport(
      cycleId,
      userId,
      reportDate,
      quantity,
      image,
      notes,
    );
  }
}
