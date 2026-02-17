import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';

class MortalityReportModel extends MortalityReport {
  MortalityReportModel({
    required super.id,
    required super.cycleId,
    required super.userId,
    required super.reportDate,
    required super.quantity,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory MortalityReportModel.fromJson(Map<String, dynamic> json) {
    return MortalityReportModel(
      id: json['id'],
      cycleId: json['cycle_id'],
      userId: json['user_id'],
      reportDate: json['report_date'],
      quantity: json['quantity'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}
