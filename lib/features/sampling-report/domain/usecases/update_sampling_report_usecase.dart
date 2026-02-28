import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/repositories/sampling_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class UpdateSamplingReportUsecase {
  final SamplingReportRepository repository;

  UpdateSamplingReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String id,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile? image,
  ) {
    return repository.updateSamplingReport(
      id,
      reportDate,
      quantity,
      averageWeight,
      image,
    );
  }
}
