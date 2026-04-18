import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/datasources/inventory_submission_datasource.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/models/inventory_submission_detail_model.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/models/inventory_submission_model.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_submission_repository.dart';
import 'package:dartz/dartz.dart';

class InventorySubmissionRepositoryImpl
    implements InventorySubmissionRepository {
  final InventorySubmissionDatasource datasource;

  InventorySubmissionRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<InventorySubmission>>>
  getInventorySubmissions() async {
    final result = await datasource.getInventorySubmissions();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final inventorySubmissions = data
            .map((json) => InventorySubmissionModel.fromJson(json))
            .toList();
        return Right(inventorySubmissions);
      } catch (e) {
        return Left(
          InvalidInputFailure(
            'Gagal mengkonversi data pengajuan inventaris: $e',
          ),
        );
      }
    });
  }

  @override
  Future<Either<Failure, InventorySubmissionDetail>> getInventorySubmission(
    String id,
  ) async {
    final result = await datasource.getInventorySubmission(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final inventorySubmission = InventorySubmissionDetailModel.fromJson(
          data,
        );
        return Right(inventorySubmission);
      } catch (e) {
        return Left(
          InvalidInputFailure(
            'Gagal mengkonversi data pengajuan inventaris: $e',
          ),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createInventorySubmission(
    String inventoryId,
    int quantity,
    String transactionType,
    String? notes,
  ) async {
    final result = await datasource.createInventorySubmission(
      inventoryId,
      quantity,
      transactionType,
      notes,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateInventorySubmission(
    String id,
    String inventoryId,
    int quantity,
    String transactionType,
    String? notes,
  ) async {
    final result = await datasource.updateInventorySubmission(
      id,
      inventoryId,
      quantity,
      transactionType,
      notes,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteInventorySubmission(
    String id,
  ) async {
    final result = await datasource.deleteInventorySubmission(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
