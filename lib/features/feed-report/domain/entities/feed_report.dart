class FeedReport {
  final String userId;
  final String user;
  final String id;
  final String cycleId;
  final String inventoryId;
  final String type;
  final String reportDate;
  final String quantity;
  final String image;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  FeedReport({
    required this.userId,
    required this.user,
    required this.id,
    required this.cycleId,
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
