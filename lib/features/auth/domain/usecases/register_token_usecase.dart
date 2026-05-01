import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterTokenUsecase {
  final AuthRepository repository;

  RegisterTokenUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String fcmToken,
    String deviceName,
    String deviceType,
  ) {
    return repository.registerToken(fcmToken, deviceName, deviceType);
  }
}
