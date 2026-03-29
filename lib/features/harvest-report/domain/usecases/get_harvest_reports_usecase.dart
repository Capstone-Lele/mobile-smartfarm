import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/repositories/harvest_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetHarvestReportsUsecase {
  final HarvestReportRepository repository;

  GetHarvestReportsUsecase(this.repository);

  Future<Either<Failure, List<HarvestReport>>> execute(String poolId) {
    return repository.getHarvestReports(poolId);
  }
}
