import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/user/data/datasources/user_datasource.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/domain/repositories/user_repository.dart';
import 'package:budidaya_lele_mobile/features/user/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, User>> getUserInfo() async {
    final result = await datasource.getUserInfo();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final user = UserModel.fromJson(data);
        return Right(user);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data pengguna: $e"),
        );
      }
    });
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

  @override
  Future<Either<Failure, Map<String, dynamic>>> changeProfile(
    String name,
    XFile? image,
  ) async {
    final result = await datasource.changeProfile(name, image);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
