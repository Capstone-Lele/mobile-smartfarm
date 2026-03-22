import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/repositories/move_pool_report_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteMovePoolReportUsecase {
  final MovePoolReportRepository repository;

  DeleteMovePoolReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteMovePoolReport(id);
  }
}
