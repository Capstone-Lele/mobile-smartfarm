import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/feeding_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteFeedingUsecase {
  final FeedingRepository repository;

  DeleteFeedingUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteFeedingSchedule(id);
  }
}
