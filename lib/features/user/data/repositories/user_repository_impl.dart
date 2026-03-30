import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/user/data/datasources/user_datasource.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/domain/repositories/user_repository.dart';
import 'package:budidaya_lele_mobile/features/user/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, User>> getUserInfo() async {
    final result = await datasource.getUserInfo();

    return result.fold(
      (failure) => Left(failure),
      (data) => Right(UserModel.fromJson(data)),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final result = await datasource.changePassword(oldPassword, newPassword);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
