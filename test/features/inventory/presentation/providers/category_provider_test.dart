import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/category.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/repositories/category_repository.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/usecases/category/get_categories_usecase.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/category_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCategoryRepository implements CategoryRepository {
  Future<Either<Failure, List<Category>>> Function()? _getListCallback;

  void setupGetList(Future<Either<Failure, List<Category>>> Function() callback) =>
      _getListCallback = callback;

  @override
  Future<Either<Failure, List<Category>>> getCategories() {
    if (_getListCallback != null) return _getListCallback!();
    return Future.value(Right<Failure, List<Category>>([]));
  }
}

Category _makeCategory({String id = 'cat-1'}) =>
    Category(id: id, name: 'Vitamin');

void main() {
  late FakeCategoryRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeCategoryRepository();
  });

  group('CategoryListNotifier', () {
    late CategoryListNotifier notifier;

    setUp(() {
      notifier = CategoryListNotifier(GetCategoriesUsecase(fakeRepository));
    });

    test('getCategories should return data on success', () async {
      // Arrange
      fakeRepository.setupGetList(
        () async => Right<Failure, List<Category>>([
          _makeCategory(),
          _makeCategory(id: 'cat-2'),
        ]),
      );

      // Act
      await notifier.getCategories();

      // Assert
      expect(notifier.state, isA<AsyncData<List<Category>>>());
      final data = (notifier.state as AsyncData<List<Category>>).value;
      expect(data.length, 2);
      expect(data.first.name, 'Vitamin');
    });

    test('categoryListNotifierProvider should be initialized with AsyncData([])', () {
      final container = ProviderContainer(
        overrides: [
          getCategoriesUseCaseProvider.overrideWithValue(
            GetCategoriesUsecase(fakeRepository),
          ),
        ],
      );

      final state = container.read(categoryListNotifierProvider);

      expect(state.hasValue, true);
      expect(state.value, isEmpty);
    });

    test('getCategories should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupGetList(
        () async => Left<Failure, List<Category>>(FetchFailure('Network error')),
      );

      // Act
      await notifier.getCategories();

      // Assert
      expect(notifier.state, isA<AsyncError>());
      final error = (notifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
