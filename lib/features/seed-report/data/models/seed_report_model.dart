import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report.dart';

class SeedReportModel extends SeedReport {
  SeedReportModel({
    required super.user,
    required super.poolName,
    required super.poolCategory,
    required super.id,
    required super.poolId,
    required super.userId,
    required super.reportDate,
    required super.initialQuantity,
    required super.currentQuantity,
    required super.initialAverageWeight,
    required super.image,
    required super.condition,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory SeedReportModel.fromJson(Map<String, dynamic> json) {
    return SeedReportModel(
      user: json['user'],
      poolName: json['poolName'],
      poolCategory: json['poolCategory'],
      id: json['id'],
      poolId: json['poolId'],
      userId: json['userId'],
      reportDate: json['reportDate'],
      initialQuantity: json['initialQuantity'],
      currentQuantity: json['currentQuantity'],
      initialAverageWeight: json['initialAverageWeight'],
      image: json['image'],
      condition: json['condition'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
