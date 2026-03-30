import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:dartz/dartz.dart';

class GetPoolUsecase {
  final PoolRepository repository;

  GetPoolUsecase(this.repository);

  Future<Either<Failure, Pool>> execute(String id) {
    return repository.getPool(id);
  }
}
