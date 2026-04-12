class InventorySubmission {
  final String id;
  final String userId;
  final String user;
  final String inventoryId;
  final String product;
  final String category;
  final int quantity;
  final String unit;
  final String status;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  InventorySubmission({
    required this.id,
    required this.userId,
    required this.user,
    required this.inventoryId,
    required this.product,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
