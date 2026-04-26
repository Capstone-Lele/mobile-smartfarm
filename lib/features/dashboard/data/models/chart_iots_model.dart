import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/chart_iots.dart';

class ChartIotsModel extends ChartIots {
  ChartIotsModel({
    required super.nodeId,
    required super.ph,
    required super.temp,
    required super.createdAt,
  });

  factory ChartIotsModel.fromJson(Map<String, dynamic> json) {
    return ChartIotsModel(
      nodeId: json['nodeId'],
      ph: json['ph'],
      temp: json['temp'],
      createdAt: json['createdAt'],
    );
  }
}
