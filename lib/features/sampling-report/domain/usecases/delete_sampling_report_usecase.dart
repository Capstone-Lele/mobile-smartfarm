import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/repositories/sampling_report_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteSamplingReportUsecase {
  final SamplingReportRepository repository;

  DeleteSamplingReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteSamplingReport(id);
  }
}
