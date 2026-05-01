import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/notification/data/datasources/notification_datasource.dart';
import 'package:budidaya_lele_mobile/features/notification/data/models/notification_detail_model.dart';
import 'package:budidaya_lele_mobile/features/notification/data/models/notification_model.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification_detail.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDatasource datasource;

  NotificationRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Notification>>> getNotifications() async {
    final result = await datasource.getNotifications();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final samplingReports = data
            .map((json) => NotificationModel.fromJson(json))
            .toList();
        return Right(samplingReports);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data notifikasi: $e"),
        );
      }
    });
  }

  @override
  Future<Either<Failure, NotificationDetail>> getNotification(String id) async {
    final result = await datasource.getNotification(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final notification = NotificationDetailModel.fromJson(data);
        return Right(notification);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data notifikasi: $e"),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateNotifications(
    String readedAt,
  ) async {
    final result = await datasource.updateNotifications(readedAt);

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateNotification(
    String id,
    String readedAt,
  ) async {
    final result = await datasource.updateNotification(id, readedAt);

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }
}
