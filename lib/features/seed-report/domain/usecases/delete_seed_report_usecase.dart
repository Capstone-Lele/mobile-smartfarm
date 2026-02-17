import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/repositories/seed_report_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteSeedReportUsecase {
  final SeedReportRepository repository;

  DeleteSeedReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteSeedReport(id);
  }
}
