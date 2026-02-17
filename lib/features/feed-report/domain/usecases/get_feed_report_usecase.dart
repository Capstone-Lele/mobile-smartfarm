import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/repositories/feed_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetFeedReportUsecase {
  final FeedReportRepository repository;

  GetFeedReportUsecase(this.repository);

  Future<Either<Failure, FeedReport>> execute(String id) {
    return repository.getFeedReport(id);
  }
}
