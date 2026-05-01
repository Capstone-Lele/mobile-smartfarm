import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/auth/data/datasources/auth_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, Auth>> login(String email, String password) async {
    final result = await datasource.login(email, password);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final auth = AuthModel.fromJson(data);
        return Right(auth);
      } catch (e) {
        return Left(InvalidInputFailure('Gagal mengkonversi data login: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> registerToken(
    String fcmToken,
    String deviceName,
    String deviceType,
  ) async {
    final result = await datasource.registerToken(
      fcmToken,
      deviceName,
      deviceType,
    );

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> unregisterToken(
    String fcmToken,
  ) async {
    final result = await datasource.unregisterToken(fcmToken);

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }
}
