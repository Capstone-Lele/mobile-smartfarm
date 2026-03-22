import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/repositories/sick_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetSickReportUsecase {
  final SickReportRepository repository;

  GetSickReportUsecase(this.repository);

  Future<Either<Failure, SickReport>> execute(String id) {
    return repository.getSickReport(id);
  }
}
