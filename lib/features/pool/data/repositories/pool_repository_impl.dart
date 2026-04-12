import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool/data/datasource/pool_datasource.dart';
import 'package:budidaya_lele_mobile/features/pool/data/models/pool_detail_model.dart';
import 'package:budidaya_lele_mobile/features/pool/data/models/pool_model.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:dartz/dartz.dart';

class PoolRepositoryImpl implements PoolRepository {
  final PoolDatasource datasource;

  PoolRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Pool>>> getPools() async {
    final result = await datasource.getPools();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final pools = data.map((json) => PoolModel.fromJson(json)).toList();
        return Right(pools);
      } catch (e) {
        return Left(InvalidInputFailure("Gagal mengkonversi data kolam: $e"));
      }
    });
  }

  @override
  Future<Either<Failure, PoolDetail>> getPool(String id) async {
    final result = await datasource.getPool(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final pool = PoolDetailModel.fromJson(data);
        return Right(pool);
      } catch (e) {
        return Left(InvalidInputFailure("Gagal mengkonversi data kolam: $e"));
      }
    });
  }
}
