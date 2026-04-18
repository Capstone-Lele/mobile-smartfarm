import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/datasources/category_datasource.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/models/category_model.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/category.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource datasource;

  CategoryRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    final result = await datasource.getCategories();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final categories = data
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        return Right(categories);
      } catch (e) {
        return Left(
          InvalidInputFailure('Gagal mengkonversi data kategori: $e'),
        );
      }
    });
  }
}
