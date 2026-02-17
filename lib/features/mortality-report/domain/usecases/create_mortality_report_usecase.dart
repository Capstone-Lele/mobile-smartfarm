import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/repositories/mortality_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreateMortalityReportUsecase {
  final MortalityReportRepository repository;

  CreateMortalityReportUsecase(this.repository);

  Future<Either<Failure, MortalityReport>> execute(
    String cycleId,
    String userId,
    String reportDate,
    int quantity,
    XFile image,
  ) {
    return repository.createMortalityReport(
      cycleId,
      userId,
      reportDate,
      quantity,
      image,
    );
  }
}
