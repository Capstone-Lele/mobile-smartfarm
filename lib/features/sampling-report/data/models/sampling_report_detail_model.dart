import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report_detail.dart';

class SamplingReportDetailModel extends SamplingReportDetail {
  SamplingReportDetailModel({
    required super.userId,
    required super.user,
    required super.poolName,
    required super.cycleCondition,
    required super.id,
    required super.cycleId,
    required super.reportDate,
    required super.quantity,
    required super.averageWeight,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory SamplingReportDetailModel.fromJson(Map<String, dynamic> json) {
    return SamplingReportDetailModel(
      userId: json['userId'],
      user: json['user'],
      poolName: json['poolName'],
      cycleCondition: json['cycleCondition'],
      id: json['id'],
      cycleId: json['cycleId'],
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
