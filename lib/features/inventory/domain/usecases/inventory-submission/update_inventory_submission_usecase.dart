import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_submission_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateInventorySubmissionUsecase {
  final InventorySubmissionRepository repository;

  UpdateInventorySubmissionUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String id,
    String inventoryId,
    int quantity,
    String transactionType,
    String? notes,
  ) {
    return repository.updateInventorySubmission(
      id,
      inventoryId,
      quantity,
      transactionType,
      notes,
    );
  }
}
