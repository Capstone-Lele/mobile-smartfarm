import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/auth/data/datasources/auth_datasource.dart';
import 'package:budidaya_lele_mobile/features/auth/data/models/user_model.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/entities/user.dart';
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

    return result.fold(
      (failure) => Left(failure),
      (data) => Right(AuthModel.fromJson(data)),
    );
  }

  @override
  Future<Either<Failure, User>> getUserInfo() async {
    final result = await datasource.getUserInfo();

    return result.fold(
      (failure) => Left(failure),
      (data) => Right(UserModel.fromJson(data)),
    );
  }
}
