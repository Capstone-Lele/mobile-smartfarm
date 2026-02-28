import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/repositories/pool_cleaning_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetPoolCleaningReportsUsecase {
  final PoolCleaningReportRepository repository;

  GetPoolCleaningReportsUsecase(this.repository);

  Future<Either<Failure, List<PoolCleaningReport>>> execute() {
    return repository.getPoolCleaningReports();
  }
}
