class SeedReportDetail {
  final String id;
  final String poolId;
  final String userId;
  final String reportDate;
  final int initialQuantity;
  final int currentQuantity;
  final String initialAverageWeight;
  final String image;
  final String? condition;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  SeedReportDetail({
    required this.id,
    required this.poolId,
    required this.userId,
    required this.reportDate,
    required this.initialQuantity,
    required this.currentQuantity,
    required this.initialAverageWeight,
    required this.image,
    required this.condition,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
