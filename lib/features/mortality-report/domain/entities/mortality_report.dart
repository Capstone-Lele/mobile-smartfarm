class MortalityReport {
  final String userId;
  final String user;
  final String poolId;
  final String poolName;
  final String poolCategory;
  final String id;
  final String cycleId;
  final String reportDate;
  final int quantity;
  final String image;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String cycleCondition;
  final String cycle;

  MortalityReport({
    required this.userId,
    required this.user,
    required this.poolId,
    required this.poolName,
    required this.poolCategory,
    required this.id,
    required this.cycleId,
    required this.reportDate,
    required this.quantity,
    required this.image,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.cycleCondition,
    required this.cycle,
  });
}
