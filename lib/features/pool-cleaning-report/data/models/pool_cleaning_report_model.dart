import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report.dart';

class PoolCleaningReportModel extends PoolCleaningReport {
  PoolCleaningReportModel({
    required super.userId,
    required super.user,
    required super.poolName,
    // required super.poolCategory,
    required super.id,
    required super.poolId,
    required super.reportDate,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory PoolCleaningReportModel.fromJson(Map<String, dynamic> json) {
    return PoolCleaningReportModel(
      userId: json['userId'],
      user: json['user'],
      poolName: json['poolName'],
      // poolCategory: json['poolCategory'],
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
