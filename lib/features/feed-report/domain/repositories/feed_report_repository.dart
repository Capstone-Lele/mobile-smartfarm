import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class FeedReportRepository {
  Future<Either<Failure, List<FeedReport>>> getFeedReports();
  Future<Either<Failure, FeedReport>> getFeedReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createFeedReport(
    String cycleId,
    String userId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  );
  Future<Either<Failure, Map<String, dynamic>>> updateFeedReport(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile? image,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteFeedReport(String id);
}
