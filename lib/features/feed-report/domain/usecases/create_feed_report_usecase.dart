import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/repositories/feed_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreateFeedReportUsecase {
  final FeedReportRepository repository;

  CreateFeedReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String cycleId,
    String userId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  ) {
    return repository.createFeedReport(
      cycleId,
      userId,
      inventoryId,
      reportDate,
      quantity,
      image,
    );
  }
}
