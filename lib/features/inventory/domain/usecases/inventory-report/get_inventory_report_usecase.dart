import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetInventoryReportUsecase {
  final InventoryReportRepository repository;

  GetInventoryReportUsecase(this.repository);

  Future<Either<Failure, InventoryReportDetail>> execute(String id) {
    return repository.getInventoryReport(id);
  }
}
