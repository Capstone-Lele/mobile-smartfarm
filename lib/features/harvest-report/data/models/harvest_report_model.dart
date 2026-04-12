import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report.dart';

class HarvestReportModel extends HarvestReport {
  HarvestReportModel({
    required super.id,
    required super.date,
    required super.userId,
    required super.user,
    required super.cycleId,
    required super.cycle,
    required super.cycleCondition,
    required super.poolId,
    required super.poolName,
    required super.poolCategory,
    required super.amount,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory HarvestReportModel.fromJson(Map<String, dynamic> json) {
    return HarvestReportModel(
      id: json['id'],
      date: json['date'],
      userId: json['userId'],
      user: json['user'],
      cycleId: json['cycleId'],
      cycle: json['cycle'],
      cycleCondition: json['cycleCondition'],
      poolId: json['poolId'],
      poolName: json['poolName'],
      poolCategory: json['poolCategory'],
      amount: json['amount'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
