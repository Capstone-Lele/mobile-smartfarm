import 'package:budidaya_lele_mobile/features/inventory/data/datasources/category_datasource.dart';
import 'package:budidaya_lele_mobile/features/inventory/data/repositories/category_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/category.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/category_repository.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/category/get_categories_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Provider Datasource
final categoryDatasourceProvider = Provider((ref) => CategoryDatasource());

// Provider Repository
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final datasource = ref.read(categoryDatasourceProvider);
  return CategoryRepositoryImpl(datasource);
});

// Provider Usecase
final getCategoriesUseCaseProvider = Provider<GetCategoriesUsecase>((ref) {
  final repository = ref.read(categoryRepositoryProvider);
  return GetCategoriesUsecase(repository);
});

class CategoryListNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final GetCategoriesUsecase _getCategoriesUsecase;

  CategoryListNotifier(this._getCategoriesUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getCategories() async {
    state = const AsyncValue.loading();
    final result = await _getCategoriesUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (categories) {
        state = AsyncValue.data(categories);
      },
    );
  }
}

// provider Utama
// Category List Notifier Provider
final categoryListNotifierProvider =
    StateNotifierProvider<CategoryListNotifier, AsyncValue<List<Category>>>((
      ref,
    ) {
      final getCategoriesUsecase = ref.read(getCategoriesUseCaseProvider);

      return CategoryListNotifier(getCategoriesUsecase);
    });
