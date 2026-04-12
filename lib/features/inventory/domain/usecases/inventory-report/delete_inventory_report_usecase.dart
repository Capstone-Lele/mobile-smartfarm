import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_report_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteInventoryReportUsecase {
  final InventoryReportRepository repository;

  DeleteInventoryReportUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String id) {
    return repository.deleteInventoryReport(id);
  }
}
