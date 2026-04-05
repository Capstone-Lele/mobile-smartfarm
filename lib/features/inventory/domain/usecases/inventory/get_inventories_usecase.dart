import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';

class GetInventoriesUsecase {
  final InventoryRepository repository;

  GetInventoriesUsecase(this.repository);

  Future<Either<Failure, List<Inventory>>> execute() {
    return repository.getInventories();
  }
}
