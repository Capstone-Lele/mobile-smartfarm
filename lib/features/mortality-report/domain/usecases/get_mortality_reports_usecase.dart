import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/repositories/mortality_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetMortalityReportsUsecase {
  final MortalityReportRepository repository;

  GetMortalityReportsUsecase(this.repository);

  Future<Either<Failure, List<MortalityReport>>> execute(String poolId) {
    return repository.getMortalityReports(poolId);
  }
}
