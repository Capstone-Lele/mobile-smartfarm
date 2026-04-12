import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report_detail.dart';

class HarvestReportDetailModel extends HarvestReportDetail {
  HarvestReportDetailModel({
    required super.userId,
    required super.user,
    required super.id,
    required super.cycleId,
    required super.reportDate,
    required super.amount,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory HarvestReportDetailModel.fromJson(Map<String, dynamic> json) {
    return HarvestReportDetailModel(
      userId: json['userId'],
      user: json['user'],
      id: json['id'],
      cycleId: json['cycleId'],
      reportDate: json['reportDate'],
      amount: json['amount'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
