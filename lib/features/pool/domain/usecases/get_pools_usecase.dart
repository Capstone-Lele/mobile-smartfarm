import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/repositories/pool_repository.dart';
import 'package:dartz/dartz.dart';

class GetPoolsUsecase {
  final PoolRepository repository;

  GetPoolsUsecase(this.repository);

  Future<Either<Failure, List<Pool>>> execute() {
    return repository.getPools();
  }
}
