import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification_detail.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetNotificationUsecase {
  final NotificationRepository repository;

  GetNotificationUsecase(this.repository);

  Future<Either<Failure, NotificationDetail>> execute(String id) {
    return repository.getNotification(id);
  }
}
