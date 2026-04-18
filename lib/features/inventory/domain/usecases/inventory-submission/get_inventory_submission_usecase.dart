import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_submission_repository.dart';
import 'package:dartz/dartz.dart';

class GetInventorySubmissionUsecase {
  final InventorySubmissionRepository repository;

  GetInventorySubmissionUsecase(this.repository);

  Future<Either<Failure, InventorySubmissionDetail>> execute(String id) {
    return repository.getInventorySubmission(id);
  }
}
