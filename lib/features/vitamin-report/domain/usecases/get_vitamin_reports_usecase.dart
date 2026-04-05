import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/repositories/vitamin_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetVitaminReportsUsecase {
  final VitaminReportRepository repository;

  GetVitaminReportsUsecase(this.repository);

  Future<Either<Failure, List<VitaminReport>>> execute(String poolId) {
    return repository.getVitaminReports(poolId);
  }
}
