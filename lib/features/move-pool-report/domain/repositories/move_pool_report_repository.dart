import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/entities/move_pool_report.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class MovePoolReportRepository {
  Future<Either<Failure, List<MovePoolReport>>> getMovePoolReports(String poolId);
  Future<Either<Failure, MovePoolReport>> getMovePoolReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createMovePoolReport(
    String originCycleId,
    String destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteMovePoolReport(String id);
}
