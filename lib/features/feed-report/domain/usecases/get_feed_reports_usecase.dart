import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/repositories/feed_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetFeedReportsUsecase {
  final FeedReportRepository repository;

  GetFeedReportsUsecase(this.repository);

  Future<Either<Failure, List<FeedReport>>> execute() {
    return repository.getFeedReports();
  }
}
