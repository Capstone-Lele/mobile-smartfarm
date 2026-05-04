import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report.dart';

class VitaminReportModel extends VitaminReport {
  VitaminReportModel({
    required super.poolId,
    required super.userId,
    required super.user,
    required super.poolName,
    required super.poolCategory,
    required super.vitaminName,
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

  factory VitaminReportModel.fromJson(Map<String, dynamic> json) {
    return VitaminReportModel(
      poolId: json['poolId'],
      userId: json['userId'],
      user: json['user'],
      poolName: json['poolName'],
      poolCategory: json['poolCategory'],
      vitaminName: json['vitaminName'],
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
