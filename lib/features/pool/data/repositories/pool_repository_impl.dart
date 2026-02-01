import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool/data/datasource/pool_datasource.dart';
import 'package:budidaya_lele_mobile/features/pool/data/models/pool_model.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:dartz/dartz.dart';

class PoolRepositoryImpl implements PoolRepository {
  final PoolDatasource datasource;

  PoolRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Pool>>> getPools() async {
    final result = await datasource.getPools();

    return result.fold((failure) => Left(failure), (data) {
      final pools = data.map((json) => PoolModel.fromJson(json)).toList();
      return Right(pools);
    });
  }
}
