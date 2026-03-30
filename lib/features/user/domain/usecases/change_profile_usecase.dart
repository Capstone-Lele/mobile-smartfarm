import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileUsecase {
  final UserRepository repository;

  ChangeProfileUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String name,
    XFile? image,
  ) async {
    return await repository.changeProfile(name, image);
  }
}
