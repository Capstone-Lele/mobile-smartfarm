import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report.dart';

class FeedReportModel extends FeedReport {
  FeedReportModel({
    required super.poolId,
    required super.user,
    required super.poolName,
    required super.poolCategory,
    required super.feedName,
    required super.unit,
    required super.startDate,
    required super.id,
    required super.cycleId,
    required super.userId,
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
      poolId: json['poolId'],
      user: json['user'],
      poolName: json['poolName'],
      poolCategory: json['poolCategory'],
      feedName: json['feedName'],
      unit: json['unit'],
      startDate: json['startDate'],
      id: json['id'],
      cycleId: json['cycleId'],
      userId: json['userId'],
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
