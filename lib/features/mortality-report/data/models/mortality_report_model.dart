import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';

class MortalityReportModel extends MortalityReport {
  MortalityReportModel({
    required super.userId,
    required super.user,
    required super.poolId,
    required super.poolName,
    required super.poolCategory,
    required super.id,
    required super.cycleId,
    required super.reportDate,
    required super.quantity,
    required super.image,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
    required super.cycleCondition,
    required super.cycle,
  });

  factory MortalityReportModel.fromJson(Map<String, dynamic> json) {
    return MortalityReportModel(
      userId: json['userId'],
      user: json['user'],
      poolId: json['poolId'],
      poolName: json['poolName'],
      poolCategory: json['poolCategory'],
      id: json['id'],
      cycleId: json['cycleId'],
      reportDate: json['reportDate'],
      quantity: json['quantity'],
      image: json['image'],
      notes: json['notes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      cycleCondition: json['cycleCondition'],
      cycle: json['cycle'],
    );
  }
}
