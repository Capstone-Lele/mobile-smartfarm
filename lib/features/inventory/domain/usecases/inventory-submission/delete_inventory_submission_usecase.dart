import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_submission_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteInventorySubmissionUsecase {
  final InventorySubmissionRepository repository;

  DeleteInventorySubmissionUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteInventorySubmission(id);
  }
}
