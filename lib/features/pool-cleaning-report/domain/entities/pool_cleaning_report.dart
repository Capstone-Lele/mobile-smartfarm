class PoolCleaningReport {
  final String userId;
  final String user;
  final String poolName;
  // final String poolCategory;
  final String id;
  final String poolId;
  final String reportDate;
  final String image;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  PoolCleaningReport({
    required this.userId,
    required this.user,
    required this.poolName,
    // required this.poolCategory,
    required this.id,
    required this.poolId,
    required this.reportDate,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
