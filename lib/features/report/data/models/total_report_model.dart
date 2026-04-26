import 'package:budidaya_lele_mobile/features/report/domain/entities/total_report.dart';

class TotalReportModel extends TotalReport {
  TotalReportModel({
    required super.totalFeedNotes,
    required super.totalVitaminNotes,
    required super.totalMovePoolNotes,
    required super.totalSickNotes,
    required super.totalSamplingNotes,
    required super.totalCleaningNotes,
    required super.totalHarvestNotes,
    required super.totalMortalityNotes,
    required super.totalSeedNotes,
  });

  factory TotalReportModel.fromJson(Map<String, dynamic> json) {
    return TotalReportModel(
      totalFeedNotes: json['totalFeedNotes'],
      totalVitaminNotes: json['totalVitaminNotes'],
      totalMovePoolNotes: json['totalMovePoolNotes'],
      totalSickNotes: json['totalSickNotes'],
      totalSamplingNotes: json['totalSamplingNotes'],
      totalCleaningNotes: json['totalCleaningNotes'],
      totalHarvestNotes: json['totalHarvestNotes'],
      totalMortalityNotes: json['totalMortalityNotes'],
      totalSeedNotes: json['totalSeedNotes'],
    );
  }
}
