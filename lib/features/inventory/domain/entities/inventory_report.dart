class InventoryReport {
  final String id;
  final String inventoryId;
  final String product;
  final String reportDate;
  final String quantity;
  final String unit;
  final String image;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  InventoryReport({
    required this.id,
    required this.inventoryId,
    required this.product,
    required this.reportDate,
    required this.quantity,
    required this.unit,
    required this.image,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
