import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification.dart';
import 'package:dartz/dartz.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;

  GetNotificationsUsecase(this.repository);

  Future<Either<Failure, List<Notification>>> execute() {
    return repository.getNotifications();
  }
}
