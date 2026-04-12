import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:dartz/dartz.dart';

class GetPoolUsecase {
  final PoolRepository repository;

  GetPoolUsecase(this.repository);

  Future<Either<Failure, PoolDetail>> execute(String id) {
    return repository.getPool(id);
  }
}
