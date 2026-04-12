import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report_detail.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/repositories/vitamin_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetVitaminReportUsecase {
  final VitaminReportRepository repository;

  GetVitaminReportUsecase(this.repository);

  Future<Either<Failure, VitaminReportDetail>> execute(String id) {
    return repository.getVitaminReport(id);
  }
}
