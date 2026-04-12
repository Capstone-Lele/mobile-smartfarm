import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_report_repository.dart';
import 'package:dartz/dartz.dart';

class GetInventoryReportsUsecase {
  final InventoryReportRepository repository;

  GetInventoryReportsUsecase(this.repository);

  Future<Either<Failure, List<InventoryReport>>> execute() {
    return repository.getInventoryReports();
  }
}
