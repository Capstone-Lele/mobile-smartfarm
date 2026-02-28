import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report.dart';

class SamplingReportModel extends SamplingReport {
  SamplingReportModel({
    required super.user,
    required super.poolName,
    required super.id,
    required super.cycleId,
    required super.userId,
    required super.reportDate,
    required super.quantity,
    required super.averageWeight,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory SamplingReportModel.fromJson(Map<String, dynamic> json) {
    return SamplingReportModel(
      user: json['user'],
      poolName: json['poolName'],
      id: json['id'],
      cycleId: json['cycleId'],
      userId: json['userId'],
      reportDate: json['reportDate'],
      quantity: json['quantity'],
      averageWeight: json['averageWeight'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
