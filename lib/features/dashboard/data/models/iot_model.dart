import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';

class IotModel extends Iot {
  IotModel({
    required super.nodeId,
    required super.ph,
    required super.temp,
    required super.receivedAt,
  });

  factory IotModel.fromJson(Map<String, dynamic> json) {
    return IotModel(
      nodeId: json['node_id'],
      ph: json['ph'],
      temp: json['temp'],
      receivedAt: json['receivedAt'],
    );
  }
}
