import 'package:budidaya_lele_mobile/features/notification/domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    required super.id,
    required super.poolId,
    required super.userId,
    required super.title,
    required super.message,
    required super.category,
    required super.type,
    required super.readedAt,
    required super.createdAt,
    required super.deletedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      poolId: json['pool_id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      category: json['category'],
      type: json['type'],
      readedAt: json['readedAt'],
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
