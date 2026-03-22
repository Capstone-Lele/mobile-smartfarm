import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/repositories/sick_report_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteSickReportUsecase {
  final SickReportRepository repository;

  DeleteSickReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteSickReport(id);
  }
}
