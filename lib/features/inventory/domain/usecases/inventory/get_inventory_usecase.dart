import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';

class GetInventoryUsecase {
  final InventoryRepository repository;

  GetInventoryUsecase(this.repository);

  Future<Either<Failure, InventoryDetail>> execute(String id) {
    return repository.getInventory(id);
  }
}
