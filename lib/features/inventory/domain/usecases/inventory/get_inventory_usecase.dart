import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';

class GetInventoryUsecase {
  final InventoryRepository repository;

  GetInventoryUsecase(this.repository);

  Future<Either<Failure, Inventory>> execute(String id) {
    return repository.getInventory(id);
  }
}
