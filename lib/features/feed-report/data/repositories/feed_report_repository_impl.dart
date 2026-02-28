import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/feed-report/data/datasources/feed_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/feed-report/data/models/feed_report_model.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report.dart';
import 'package:budidaya_lele_mobile/features/feed-report/domain/repositories/feed_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class FeedReportRepositoryImpl implements FeedReportRepository {
  final FeedReportDatasource datasource;

  FeedReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<FeedReport>>> getFeedReports() async {
    final result = await datasource.getFeedReports();

    return result.fold((failure) => Left(failure), (data) {
      final feedReports = data
          .map((json) => FeedReportModel.fromJson(json))
          .toList();
      return Right(feedReports);
    });
  }

  @override
  Future<Either<Failure, FeedReport>> getFeedReport(String id) async {
    final result = await datasource.getFeedReport(id);

    return result.fold((failure) => Left(failure), (data) {
      final feedReport = FeedReportModel.fromJson(data);
      return Right(feedReport);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createFeedReport(
    String cycleId,
    String userId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  ) async {
    final result = await datasource.createFeedReport(
      cycleId,
      userId,
      inventoryId,
      reportDate,
      quantity,
      image,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateFeedReport(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile? image,
  ) async {
    final result = await datasource.updateFeedReport(
      id,
      inventoryId,
      reportDate,
      quantity,
      image,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteFeedReport(
    String id,
  ) async {
    final result = await datasource.deleteFeedReport(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
