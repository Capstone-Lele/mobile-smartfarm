import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report.dart';

class SickReportModel extends SickReport {
  SickReportModel({
    required super.originPoolName,
    required super.originCategory,
    required super.destinationPoolName,
    required super.destinationCategory,
    required super.user,
    required super.id,
    required super.originCycleId,
    required super.destinationCycleId,
    required super.userId,
    required super.reportDate,
    required super.quantity,
    required super.image,
    required super.type,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory SickReportModel.fromJson(Map<String, dynamic> json) {
    return SickReportModel(
      originPoolName: json['originPoolName'],
      originCategory: json['originCategory'],
      destinationPoolName: json['destinationPoolName'],
      destinationCategory: json['destinationCategory'],
      user: json['user'],
      id: json['id'],
      originCycleId: json['originCycleId'],
      destinationCycleId: json['destinationCycleId'],
      userId: json['userId'],
      reportDate: json['reportDate'],
      quantity: json['quantity'],
      image: json['image'],
      type: json['type'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
