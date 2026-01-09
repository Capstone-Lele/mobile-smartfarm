import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/auth.dart';

abstract class AuthRepository {
  Future<Either<Failure, Auth>> login(String email, String password);
}
