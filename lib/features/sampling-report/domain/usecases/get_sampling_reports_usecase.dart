import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/repositories/sampling_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetSamplingReportsUsecase {
  final SamplingReportRepository repository;

  GetSamplingReportsUsecase(this.repository);

  Future<Either<Failure, List<SamplingReport>>> execute() {
    return repository.getSamplingReports();
  }
}
