import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report.dart';

class SeedReportModel extends SeedReport {
  SeedReportModel({
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
      id: json['id'],
      poolId: json['pool_id'],
      userId: json['user_id'],
      reportDate: json['report_date'],
      initialQuantity: json['initial_quantity'],
      currentQuantity: json['current_quantity'],
      initialAverageWeight: json['initial_average_weight'],
      image: json['image'],
      condition: json['condition'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}
