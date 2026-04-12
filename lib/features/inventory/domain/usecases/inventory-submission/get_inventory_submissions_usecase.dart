import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_submission_repository.dart';
import 'package:dartz/dartz.dart';

class GetInventorySubmissionsUsecase {
  final InventorySubmissionRepository repository;

  GetInventorySubmissionsUsecase(this.repository);

  Future<Either<Failure, List<InventorySubmission>>> execute() {
    return repository.getInventorySubmissions();
  }
}
