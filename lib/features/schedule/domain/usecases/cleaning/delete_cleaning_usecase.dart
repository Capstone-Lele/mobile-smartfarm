import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/cleaning_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteCleaningUsecase {
  final CleaningRepository repository;

  DeleteCleaningUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteCleaningSchedule(id);
  }
}