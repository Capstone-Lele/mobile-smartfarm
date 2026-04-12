import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/datasources/inventory_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/models/inventory_report_model.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class InventoryReportRepositoryImpl implements InventoryReportRepository {
  final InventoryReportDatasource datasource;

  InventoryReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<InventoryReport>>> getInventoryReports() async {
    final result = await datasource.getInventoryReports();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final inventoryReports = data
            .map((json) => InventoryReportModel.fromJson(json))
            .toList();
        return Right(inventoryReports);
      } catch (e) {
        return Left(
          InvalidInputFailure('Gagal mengkonversi data laporan inventaris: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, InventoryReport>> getInventoryReport(String id) async {
    final result = await datasource.getInventoryReport(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final inventoryReport = InventoryReportModel.fromJson(data);
        return Right(inventoryReport);
      } catch (e) {
        return Left(
          InvalidInputFailure('Gagal mengkonversi data laporan inventaris: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createInventoryReport(
    String inventoryId,
    String reportDate,
    int quantity,
    String type,
    XFile image,
    String? notes,
  ) async {
    final result = await datasource.createInventoryReport(
      inventoryId,
      reportDate,
      quantity,
      type,
      image,
      notes,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateInventoryReport(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    String type,
    XFile? image,
    String? notes,
  ) async {
    final result = await datasource.updateInventoryReport(
      id,
      inventoryId,
      reportDate,
      quantity,
      type,
      image,
      notes,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteInventoryReport(
    String id,
  ) async {
    final result = await datasource.deleteInventoryReport(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
