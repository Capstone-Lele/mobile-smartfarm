class ActivityLog {
  final String id;
  final String reportId;
  final String user;
  final String poolName;
  final String activity;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  ActivityLog({
    required this.id,
    required this.reportId,
    required this.user,
    required this.poolName,
    required this.activity,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
