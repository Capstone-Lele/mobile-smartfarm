import 'package:budidaya_lele_mobile/features/feed-report/domain/entities/feed_report_detail.dart';

class FeedReportDetailModel extends FeedReportDetail {
  FeedReportDetailModel({
    required super.userId,
    required super.user,
    required super.foodName,
    required super.unit,
    required super.id,
    required super.cycleId,
    required super.inventoryId,
    required super.type,
    required super.reportDate,
    required super.quantity,
    required super.image,
    required super.cycleCondition,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory FeedReportDetailModel.fromJson(Map<String, dynamic> json) {
    return FeedReportDetailModel(
      userId: json['userId'],
      user: json['user'],
      foodName: json['foodName'],
      unit: json['unit'],
      id: json['id'],
      cycleId: json['cycleId'],
      inventoryId: json['inventoryId'],
      type: json['type'],
      reportDate: json['reportDate'],
      quantity: json['quantity'],
      image: json['image'],
      cycleCondition: json['cycleCondition'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
