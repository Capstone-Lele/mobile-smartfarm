import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report.dart';

class FeedReportModel extends FeedReport {
  FeedReportModel({
    required super.userId,
    required super.user,
    required super.id,
    required super.cycleId,
    required super.inventoryId,
    required super.type,
    required super.reportDate,
    required super.quantity,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory FeedReportModel.fromJson(Map<String, dynamic> json) {
    return FeedReportModel(
      userId: json['userId'],
      user: json['user'],
      id: json['id'],
      cycleId: json['cycleId'],
      inventoryId: json['inventoryId'],
      type: json['type'],
      reportDate: json['reportDate'],
      quantity: json['quantity'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
