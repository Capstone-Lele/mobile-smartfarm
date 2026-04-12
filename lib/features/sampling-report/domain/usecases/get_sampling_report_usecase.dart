import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report_detail.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/repositories/sampling_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetSamplingReportUsecase {
  final SamplingReportRepository repository;

  GetSamplingReportUsecase(this.repository);

  Future<Either<Failure, SamplingReportDetail>> execute(String id) {
    return repository.getSamplingReport(id);
  }
}
