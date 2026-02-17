import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/repositories/seed_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetSeedReportUsecase {
  final SeedReportRepository repository;

  GetSeedReportUsecase(this.repository);

  Future<Either<Failure, SeedReport>> execute(String id) {
    return repository.getSeedReport(id);
  }
}
