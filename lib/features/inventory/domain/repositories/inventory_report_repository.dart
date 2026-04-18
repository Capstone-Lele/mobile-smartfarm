import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class InventoryReportRepository {
  Future<Either<Failure, List<InventoryReport>>> getInventoryReports();
  Future<Either<Failure, InventoryReportDetail>> getInventoryReport(String id);
  Future<Either<Failure, Map<String, dynamic>>> createInventoryReport(
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
    String? notes,
  );
}
