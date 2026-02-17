class FeedReport {
  final String id;
  final String userId;
  final String inventoryId;
  final String type;
  final String reportDate;
  final int quantity;
  final String image;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  FeedReport({
    required this.id,
    required this.userId,
    required this.inventoryId,
    required this.type,
    required this.reportDate,
    required this.quantity,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
