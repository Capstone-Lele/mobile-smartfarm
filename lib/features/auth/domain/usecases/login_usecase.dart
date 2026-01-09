import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/auth.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, Auth>> execute(String email, String password) {
    return repository.login(email, password);
  }
}
