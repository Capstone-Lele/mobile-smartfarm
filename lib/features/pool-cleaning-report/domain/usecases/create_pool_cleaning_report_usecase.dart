import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/repositories/pool_cleaning_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreatePoolCleaningReportUsecase {
  final PoolCleaningReportRepository repository;

  CreatePoolCleaningReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String poolId,
    String reportDate,
    XFile image,
  ) {
    return repository.createPoolCleaningReport(poolId, reportDate, image);
  }
}
