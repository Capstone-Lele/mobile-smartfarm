import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/category.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class GetCategoriesUsecase {
  final CategoryRepository repository;

  GetCategoriesUsecase(this.repository);

  Future<Either<Failure, List<Category>>> execute() {
    return repository.getCategories();
  }
}
