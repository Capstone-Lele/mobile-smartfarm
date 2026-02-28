import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report.dart';

class HarvestReportModel extends HarvestReport {
  HarvestReportModel({
    required super.id,
    required super.date,
    required super.cycle,
    required super.poolName,
    required super.amount,
    required super.user,
  });

  factory HarvestReportModel.fromJson(Map<String, dynamic> json) {
    return HarvestReportModel(
      id: json['id'],
      date: json['date'],
      cycle: json['cycle'],
      poolName: json['poolName'],
      amount: json['amount'],
      user: json['user'],
    );
  }
}
