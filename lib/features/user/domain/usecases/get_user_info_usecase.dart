import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserInfoUsecase {
  final UserRepository repository;

  GetUserInfoUsecase(this.repository);

  Future<Either<Failure, User>> execute() {
    return repository.getUserInfo();
  }
}
