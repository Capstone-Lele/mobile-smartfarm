class ActivityLog {
  final String id;
  final String noteId;
  final String userId;
  final String userName;
  final String poolName;
  final String activity;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String notes;

  ActivityLog({
    required this.id,
    required this.noteId,
    required this.userId,
    required this.userName,
    required this.poolName,
    required this.activity,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.notes,
  });
}
