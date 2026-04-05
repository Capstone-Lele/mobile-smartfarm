import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/datasources/inventory_datasource.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/models/inventory_model.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryDatasource datasource;

  InventoryRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Inventory>>> getInventories() async {
    final result = await datasource.getInventories();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final inventories =
            data.map((json) => InventoryModel.fromJson(json)).toList();
        return Right(inventories);
      } catch (e) {
        return Left(
          InvalidInputFailure('Gagal mengkonversi data inventaris: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Inventory>> getInventory(String id) async {
    final result = await datasource.getInventory(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final inventory = InventoryModel.fromJson(data);
        return Right(inventory);
      } catch (e) {
        return Left(
          InvalidInputFailure('Gagal mengkonversi data inventaris: $e'),
        );
      }
    });
  }
}
