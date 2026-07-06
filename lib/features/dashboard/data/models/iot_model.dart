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

  /// Parses the realtime `pool-data` payload pushed over Socket.IO.
  /// Values may arrive as int or double, and `node_id` as int or String.
  factory IotModel.fromSocket(Map<String, dynamic> json) {
    return IotModel(
      nodeId: json['node_id'] is int
          ? json['node_id'] as int
          : int.tryParse(json['node_id'].toString()) ?? 0,
      ph: (json['ph'] as num?)?.toDouble() ?? 0.0,
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      receivedAt: json['receivedAt']?.toString() ?? '',
    );
  }
}
