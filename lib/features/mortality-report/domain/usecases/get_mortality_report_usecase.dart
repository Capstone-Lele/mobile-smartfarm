import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/repositories/mortality_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetMortalityReportUsecase {
  final MortalityReportRepository repository;

  GetMortalityReportUsecase(this.repository);

  Future<Either<Failure, MortalityReport>> execute(String id) {
    return repository.getMortalityReport(id);
  }
}
