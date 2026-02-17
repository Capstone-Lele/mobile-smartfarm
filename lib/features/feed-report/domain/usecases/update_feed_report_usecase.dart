import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/repositories/feed_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class UpdateFeedReportUsecase {
  final FeedReportRepository repository;

  UpdateFeedReportUsecase(this.repository);

  Future<Either<Failure, FeedReport>> execute(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile? image,
  ) {
    return repository.updateFeedReport(
      id,
      inventoryId,
      reportDate,
      quantity,
      image,
    );
  }
}
