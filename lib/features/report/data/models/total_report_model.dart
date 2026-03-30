import 'package:budidaya_lele_mobile/features/report/domain/entities/total_report.dart';

class TotalReportModel extends TotalReport {
  TotalReportModel({
    required super.totalFeedReports,
    required super.totalVitaminReports,
    required super.totalMortalityReports,
    required super.totalSickReports,
    required super.totalCleaningReports,
    required super.totalSamplingReports,
    required super.totalSeedReports,
    required super.totalHarvestReports,
    required super.totalMovePoolReports,
  });

  factory TotalReportModel.fromJson(Map<String, dynamic> json) {
    return TotalReportModel(
      totalFeedReports: json['totalFeedReports'],
      totalVitaminReports: json['totalVitaminReports'],
      totalMortalityReports: json['totalMortalityReports'],
      totalSickReports: json['totalSickReports'],
      totalCleaningReports: json['totalCleaningReports'],
      totalSamplingReports: json['totalSamplingReports'],
      totalSeedReports: json['totalSeedReports'],
      totalHarvestReports: json['totalHarvestReports'],
      totalMovePoolReports: json['totalMovePoolReports'],
    );
  }
}
