class MortalityReportDetail {
  final String userId;
  final String user;
  final String id;
  final String cycleId;
  final String reportDate;
  final int quantity;
  final String image;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  MortalityReportDetail({
    required this.userId,
    required this.user,
    required this.id,
    required this.cycleId,
    required this.reportDate,
    required this.quantity,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
