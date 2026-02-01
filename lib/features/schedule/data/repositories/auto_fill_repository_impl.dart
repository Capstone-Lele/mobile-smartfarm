import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/datasource/auto_fill_datasource.dart';
import 'package:budidaya_lele_mobile/features/schedule/data/models/auto_fill_model.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/auto_fill.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/repositories/auto_fill_repository.dart';
import 'package:dartz/dartz.dart';

class AutoFillRepositoryImpl implements AutoFillRepository {
  final AutoFillDatasource datasource;

  AutoFillRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<AutoFill>>> getAutoFills(String id) async {
    final result = await datasource.getAutoFills(id);

    return result.fold((failure) => Left(failure), (data) {
      final autoFills = data
          .map((json) => AutoFillModel.fromJson(json))
          .toList();
      return Right(autoFills);
    });
  }
}
