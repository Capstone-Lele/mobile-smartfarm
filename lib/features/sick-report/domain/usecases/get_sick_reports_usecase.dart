import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/repositories/sick_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetSickReportsUsecase {
  final SickReportRepository repository;

  GetSickReportsUsecase(this.repository);

  Future<Either<Failure, List<SickReport>>> execute(String poolId) {
    return repository.getSickReports(poolId);
  }
}
