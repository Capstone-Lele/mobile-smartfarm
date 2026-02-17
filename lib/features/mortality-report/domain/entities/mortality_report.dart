class MortalityReport {
  final String id;
  final String cycleId;
  final String userId;
  final String reportDate;
  final int quantity;
  final String image;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  MortalityReport({
    required this.id,
    required this.cycleId,
    required this.userId,
    required this.reportDate,
    required this.quantity,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
