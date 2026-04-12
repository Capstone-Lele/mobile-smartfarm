class SamplingReportDetail {
  final String userId;
  final String user;
  final String poolName;
  final String? cycleCondition;
  final String id;
  final String cycleId;
  final String reportDate;
  final int quantity;
  final String averageWeight;
  final String image;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  SamplingReportDetail({
    required this.userId,
    required this.user,
    required this.poolName,
    required this.cycleCondition,
    required this.id,
    required this.cycleId,
    required this.reportDate,
    required this.quantity,
    required this.averageWeight,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
