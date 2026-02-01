import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/auto_fill.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/auto_fill_repository.dart';
import 'package:dartz/dartz.dart';

class GetAutoFillsUsecase {
  final AutoFillRepository repository;

  GetAutoFillsUsecase(this.repository);

  Future<Either<Failure, List<AutoFill>>> execute(String id) {
    return repository.getAutoFills(id);
  }
}
