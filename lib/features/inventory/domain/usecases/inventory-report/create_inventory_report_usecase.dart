import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreateInventoryReportUsecase {
  final InventoryReportRepository repository;

  CreateInventoryReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
    String? notes,
  ) {
    return repository.createInventoryReport(
      inventoryId,
      reportDate,
      quantity,
      image,
      notes,
    );
  }
}
