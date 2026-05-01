import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateNotificationUsecase {
  final NotificationRepository repository;

  UpdateNotificationUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String id,
    String readedAt,
  ) {
    return repository.updateNotification(id, readedAt);
  }
}
