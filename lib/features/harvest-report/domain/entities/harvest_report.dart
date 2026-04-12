class HarvestReport {
  final String id;
  final String date;
  final String userId;
  final String user;
  final String cycleId;
  final String cycle;
  final String cycleCondition;
  final String poolId;
  final String poolName;
  final String poolCategory;
  final int amount;
  final String image;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  HarvestReport({
    required this.id,
    required this.date,
    required this.userId,
    required this.user,
    required this.cycleId,
    required this.cycle,
    required this.cycleCondition,
    required this.poolId,
    required this.poolName,
    required this.poolCategory,
    required this.amount,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
