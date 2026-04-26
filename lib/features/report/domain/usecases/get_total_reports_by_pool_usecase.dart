import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/total_report.dart';
import 'package:budidaya_lele_mobile/features/report/domain/repositories/report_repository.dart';
import 'package:dartz/dartz.dart';

class GetTotalReportsByPoolUsecase {
  final ReportRepository repository;

  GetTotalReportsByPoolUsecase(this.repository);

  Future<Either<Failure, TotalReport>> execute(String poolId, int month) {
    return repository.getTotalReportsByPool(poolId, month);
  }
}
