import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report.dart';

class SamplingReportModel extends SamplingReport {
  SamplingReportModel({
    required super.userId,
    required super.user,
    // required super.poolId,
    required super.poolName,
    // required super.poolCategory,
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

  factory SamplingReportModel.fromJson(Map<String, dynamic> json) {
    return SamplingReportModel(
      userId: json['userId'],
      user: json['user'],
      // poolId: json['poolId'],
      poolName: json['poolName'],
      // poolCategory: json['poolCategory'],
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
