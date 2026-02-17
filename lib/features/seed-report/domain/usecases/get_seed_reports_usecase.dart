import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/repositories/seed_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetSeedReportsUsecase {
  final SeedReportRepository repository;

  GetSeedReportsUsecase(this.repository);

  Future<Either<Failure, List<SeedReport>>> execute() {
    return repository.getSeedReports();
  }
}
