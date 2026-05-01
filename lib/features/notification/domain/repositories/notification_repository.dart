import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification_detail.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getNotifications();
  Future<Either<Failure, NotificationDetail>> getNotification(String id);
  Future<Either<Failure, Map<String, dynamic>>> updateNotifications(
    String readedAt,
  );
  Future<Either<Failure, Map<String, dynamic>>> updateNotification(
    String id,
    String readedAt,
  );
}
