import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/repositories/vitamin_report_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteVitaminReportUsecase {
  final VitaminReportRepository repository;

  DeleteVitaminReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteVitaminReport(id);
  }
}
