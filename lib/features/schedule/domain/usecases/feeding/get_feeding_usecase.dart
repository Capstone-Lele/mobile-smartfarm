import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/feeding_repository.dart';
import 'package:dartz/dartz.dart';

class GetFeedingUsecase {
  final FeedingRepository repository;

  GetFeedingUsecase(this.repository);

  Future<Either<Failure, Schedule>> execute(String id) {
    return repository.getFeedingSchedule(id);
  }
}