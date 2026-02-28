import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/repositories/pool_cleaning_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetPoolCleaningReportUsecase {
  final PoolCleaningReportRepository repository;

  GetPoolCleaningReportUsecase(this.repository);

  Future<Either<Failure, PoolCleaningReport>> execute(String id) {
    return repository.getPoolCleaningReport(id);
  }
}
