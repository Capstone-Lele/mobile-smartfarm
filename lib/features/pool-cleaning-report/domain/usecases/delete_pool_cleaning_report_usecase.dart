import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/repositories/pool_cleaning_report_repository.dart';
import 'package:dartz/dartz.dart';

class DeletePoolCleaningReportUsecase {
  final PoolCleaningReportRepository repository;

  DeletePoolCleaningReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deletePoolCleaningReport(id);
  }
}
