import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class UnregisterTokenUsecase {
  final AuthRepository repository;

  UnregisterTokenUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String fcmToken) {
    return repository.unregisterToken(fcmToken);
  }
}
