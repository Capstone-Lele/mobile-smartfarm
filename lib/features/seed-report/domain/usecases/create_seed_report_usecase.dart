import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/repositories/seed_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreateSeedReportUsecase {
  final SeedReportRepository repository;

  CreateSeedReportUsecase(this.repository);

  Future<Either<Failure, SeedReport>> execute(
    String poolId,
    String userId,
    String reportDate,
    int initialQuantity,
    int currentQuantity,
    double initialAverageWeight,
    XFile image,
  ) {
    return repository.createSeedReport(
      poolId,
      userId,
      reportDate,
      initialQuantity,
      currentQuantity,
      initialAverageWeight,
      image,
    );
  }
}
