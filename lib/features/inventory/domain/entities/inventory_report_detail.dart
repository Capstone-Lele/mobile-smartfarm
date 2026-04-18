class InventoryReportDetail {
  final String id;
  final String userId;
  final String inventoryId;
  final String reportDate;
  final String quantity;
  final String type;
  final String? transactionType;
  final String image;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  InventoryReportDetail({
    required this.id,
    required this.userId,
    required this.inventoryId,
    required this.reportDate,
    required this.quantity,
    required this.type,
    required this.transactionType,
    required this.image,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
