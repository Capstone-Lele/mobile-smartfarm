import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/activity_log.dart';
import 'package:budidaya_lele_mobile/features/report/domain/repositories/report_repository.dart';
import 'package:dartz/dartz.dart';

class GetActivityLogsUsecase {
  final ReportRepository repository;

  GetActivityLogsUsecase(this.repository);

  Future<Either<Failure, List<ActivityLog>>> execute() {
    return repository.getActivityLogs();
  }
}
