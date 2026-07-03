import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/utils/inventory_category_util.dart';
import 'package:flutter_test/flutter_test.dart';

Inventory _makeInventory({
  String id = 'inv-1',
  String category = 'Vitamin',
  String? deletedAt,
}) => Inventory(
  id: id,
  productId: 'product-1',
  product: 'Produk A',
  categoryId: 'cat-1',
  category: category,
  unitId: 'unit-1',
  unit: 'kg',
  totalQuantity: '10',
  minQuantity: '2',
  createdAt: '2024-01-01T00:00:00.000Z',
  updatedAt: '2024-01-01T00:00:00.000Z',
  deletedAt: deletedAt,
);

void main() {
  group('InventoryCategoryUtil.deriveCategoryNames', () {
    test('should return unique sorted category names on success', () {
      // Arrange
      final inventories = [
        _makeInventory(id: 'inv-1', category: 'Vitamin'),
        _makeInventory(id: 'inv-2', category: 'Material'),
        _makeInventory(id: 'inv-3', category: 'Vitamin'),
      ];

      // Act
      final result = InventoryCategoryUtil.deriveCategoryNames(inventories);

      // Assert
      expect(result, ['Material', 'Vitamin']);
    });

    test('should return empty list when inventories are empty', () {
      // Act
      final result = InventoryCategoryUtil.deriveCategoryNames([]);

      // Assert
      expect(result, isEmpty);
    });

    test('should ignore deleted items and empty categories', () {
      // Arrange
      final inventories = [
        _makeInventory(id: 'inv-1', category: 'Vitamin'),
        _makeInventory(
          id: 'inv-2',
          category: 'Material',
          deletedAt: '2024-02-01T00:00:00.000Z',
        ),
        _makeInventory(id: 'inv-3', category: ''),
      ];

      // Act
      final result = InventoryCategoryUtil.deriveCategoryNames(inventories);

      // Assert
      expect(result, ['Vitamin']);
    });
  });
}
