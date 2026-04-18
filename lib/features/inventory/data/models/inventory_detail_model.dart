import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_detail.dart';

class InventoryDetailModel extends InventoryDetail {
  InventoryDetailModel({
    required super.id,
    required super.productId,
    required super.product,
    required super.unitId,
    required super.unit,
    required super.totalQuantity,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory InventoryDetailModel.fromJson(Map<String, dynamic> json) {
    return InventoryDetailModel(
      id: json['id'],
      productId: json['productId'],
      product: json['product'],
      unitId: json['unitId'],
      unit: json['unit'],
      totalQuantity: json['totalQuantity'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
