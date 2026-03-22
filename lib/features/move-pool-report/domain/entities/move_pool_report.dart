class MovePoolReport {
  final String originPoolName;
  final String originCategory;
  final String destinationPoolName;
  final String destinationCategory;
  final String user;
  final String startDate;
  final String id;
  final String originCycleId;
  final String destinationCycleId;
  final String userId;
  final String reportDate;
  final int quantity;
  final String image;
  final String type;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  MovePoolReport({
    required this.originPoolName,
    required this.originCategory,
    required this.destinationPoolName,
    required this.destinationCategory,
    required this.user,
    required this.startDate,
    required this.id,
    required this.originCycleId,
    required this.destinationCycleId,
    required this.userId,
    required this.reportDate,
    required this.quantity,
    required this.image,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
