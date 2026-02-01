import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/feeding_repository.dart';
import 'package:dartz/dartz.dart';

class GetFeedingsUsecase {
  final FeedingRepository repository;

  GetFeedingsUsecase(this.repository);

  Future<Either<Failure, List<Schedule>>> execute() {
    return repository.getFeedingSchedules();
  }
}
