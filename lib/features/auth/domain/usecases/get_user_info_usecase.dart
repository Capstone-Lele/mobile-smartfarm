import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserInfoUsecase {
  final AuthRepository repository;

  GetUserInfoUsecase(this.repository);

  Future<Either<Failure, User>> execute() {
    return repository.getUserInfo();
  }
}
