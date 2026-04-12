import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class UpdateInventoryReportUsecase {
  final InventoryReportRepository repository;

  UpdateInventoryReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    String type,
    XFile? image,
    String? notes,
  ) {
    return repository.updateInventoryReport(
      id,
      inventoryId,
      reportDate,
      quantity,
      type,
      image,
      notes,
    );
  }
}
