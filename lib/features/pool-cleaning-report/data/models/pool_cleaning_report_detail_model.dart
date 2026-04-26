import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report_detail.dart';

class PoolCleaningReportDetailModel extends PoolCleaningReportDetail {
  PoolCleaningReportDetailModel({
    required super.userId,
    required super.user,
    required super.poolName,
    required super.id,
    required super.poolId,
    required super.reportDate,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory PoolCleaningReportDetailModel.fromJson(Map<String, dynamic> json) {
    return PoolCleaningReportDetailModel(
      userId: json['userId'],
      user: json['user'],
      poolName: json['poolName'],
      id: json['id'],
      poolId: json['poolId'],
      reportDate: json['reportDate'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
