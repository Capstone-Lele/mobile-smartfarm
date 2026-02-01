import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/auto_fill.dart';
import 'package:dartz/dartz.dart';

abstract class AutoFillRepository {
  Future<Either<Failure, List<AutoFill>>> getAutoFills(String id);
}
