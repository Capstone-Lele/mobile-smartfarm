import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission_detail.dart';
import 'package:dartz/dartz.dart';

abstract class InventorySubmissionRepository {
  Future<Either<Failure, List<InventorySubmission>>> getInventorySubmissions();
  Future<Either<Failure, InventorySubmissionDetail>> getInventorySubmission(
    String id,
  );
  Future<Either<Failure, Map<String, dynamic>>> createInventorySubmission(
    String inventoryId,
    int quantity,
    String transactionType,
    String notes,
  );
  Future<Either<Failure, Map<String, dynamic>>> updateInventorySubmission(
    String id,
    String inventoryId,
    int quantity,
    String transactionType,
    String notes,
  );
  Future<Either<Failure, Map<String, dynamic>>> deleteInventorySubmission(
    String id,
  );
}
