import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';

class InventoryModel extends Inventory {
  InventoryModel({
    required super.id,
    required super.productId,
    required super.product,
    required super.categoryId,
    required super.category,
    required super.unitId,
    required super.unit,
    required super.totalQuantity,
    required super.minQuantity,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      productId: json['productId'],
      product: json['product'],
      categoryId: json['categoryId'],
      category: json['category'],
      unitId: json['unitId'],
      unit: json['unit'],
      totalQuantity: json['totalQuantity'],
      minQuantity: json['minQuantity'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
