import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_detail.dart';
import 'package:dartz/dartz.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<Inventory>>> getInventories();
  Future<Either<Failure, InventoryDetail>> getInventory(String id);
}
