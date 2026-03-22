import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/entities/move_pool_report.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/repositories/move_pool_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetMovePoolReportsUsecase {
  final MovePoolReportRepository repository;

  GetMovePoolReportsUsecase(this.repository);

  Future<Either<Failure, List<MovePoolReport>>> execute() {
    return repository.getMovePoolReports();
  }
}
