import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class ChangePasswordUsecase {
  final UserRepository repository;

  ChangePasswordUsecase(this.repository);

   Future<Either<Failure, Map<String, dynamic>>> execute(
    String oldPassword,
    String newPassword,
  ) {
    return repository.changePassword(oldPassword, newPassword);
  }
}