class Notification {
  final String id;
  final String poolId;
  final String userId;
  final String title;
  final String message;
  final String category;
  final String type;
  final String? readedAt;
  final String createdAt;
  final String? deletedAt;

  Notification({
    required this.id,
    required this.poolId,
    required this.userId,
    required this.title,
    required this.message,
    required this.category,
    required this.type,
    required this.readedAt,
    required this.createdAt,
    required this.deletedAt,
  });
}
