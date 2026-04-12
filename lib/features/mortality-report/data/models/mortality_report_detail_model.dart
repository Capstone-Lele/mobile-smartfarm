import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report_detail.dart';

class MortalityReportDetailModel extends MortalityReportDetail {
  MortalityReportDetailModel({
    required super.userId,
    required super.user,
    required super.id,
    required super.cycleId,
    required super.reportDate,
    required super.quantity,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory MortalityReportDetailModel.fromJson(Map<String, dynamic> json) {
    return MortalityReportDetailModel(
      userId: json['userId'],
      user: json['user'],
      id: json['id'],
      cycleId: json['cycleId'],
      reportDate: json['reportDate'],
      quantity: json['quantity'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
