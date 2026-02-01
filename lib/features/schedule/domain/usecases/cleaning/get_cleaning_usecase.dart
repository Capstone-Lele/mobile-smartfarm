import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/cleaning_repository.dart';
import 'package:dartz/dartz.dart';

class GetCleaningUsecase {
  final CleaningRepository repository;

  GetCleaningUsecase(this.repository);

  Future<Either<Failure, Schedule>> execute(String id) {
    return repository.getCleaningSchedule(id);
  }
}