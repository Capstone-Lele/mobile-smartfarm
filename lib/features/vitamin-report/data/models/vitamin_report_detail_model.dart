import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report_detail.dart';

class VitaminReportDetailModel extends VitaminReportDetail {
  VitaminReportDetailModel({
    required super.userId,
    required super.user,
    required super.vitaminName,
    required super.unit,
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

  factory VitaminReportDetailModel.fromJson(Map<String, dynamic> json) {
    return VitaminReportDetailModel(
      userId: json['userId'],
      user: json['user'],
      vitaminName: json['vitaminName'],
      unit: json['unit'],
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
