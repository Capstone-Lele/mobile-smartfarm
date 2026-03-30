import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserInfo();
  Future<Either<Failure, Map<String, dynamic>>> changePassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<Failure, Map<String, dynamic>>> changeProfile(
    String name,
    XFile? image,
  );
}
