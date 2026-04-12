import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:dartz/dartz.dart';

abstract class PoolRepository {
  Future<Either<Failure, List<Pool>>> getPools();
  Future<Either<Failure, PoolDetail>> getPool(String id);
}
