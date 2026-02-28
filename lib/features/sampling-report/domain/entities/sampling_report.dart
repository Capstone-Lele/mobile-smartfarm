class SamplingReport {
  final String user;
  final String poolName;
  final String id;
  final String cycleId;
  final String userId;
  final String reportDate;
  final int quantity;
  final double averageWeight;
  final String image;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  SamplingReport({
    required this.user,
    required this.poolName,
    required this.id,
    required this.cycleId,
    required this.userId,
    required this.reportDate,
    required this.quantity,
    required this.averageWeight,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
