import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/repositories/harvest_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetHarvestReportUsecase {
  final HarvestReportRepository repository;

  GetHarvestReportUsecase(this.repository);

  Future<Either<Failure, HarvestReport>> execute(String id) {
    return repository.getHarvestReport(id);
  }
}
