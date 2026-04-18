class InventoryDetail {
  final String id;
  final String productId;
  final String product;
  final String unitId;
  final String unit;
  final String totalQuantity;
  final String updatedAt;
  final String? deletedAt;

  InventoryDetail({
    required this.id,
    required this.productId,
    required this.product,
    required this.unitId,
    required this.unit,
    required this.totalQuantity,
    required this.updatedAt,
    required this.deletedAt,
  });
}
