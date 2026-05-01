import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateNotificationsUsecase {
  final NotificationRepository repository;

  UpdateNotificationsUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String readedAt) {
    return repository.updateNotifications(readedAt);
  }
}
