import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';

class PoolModel extends Pool {
  PoolModel({
    required super.cycleId,
    required super.cycle,
    required super.id,
    required super.name,
    required super.category,
    required super.diameter,
    required super.length,
    required super.width,
    required super.height,
    required super.temperatureMax,
    required super.temperatureMin,
    required super.acidityMax,
    required super.acidityMin,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory PoolModel.fromJson(Map<String, dynamic> json) {
    return PoolModel(
      cycleId: json['cycleId'],
      cycle: json['cycle'],
      id: json['id'],
      name: json['name'],
      category: json['category'],
      diameter: json['diameter'],
      length: json['length'],
      width: json['width'],
      height: json['height'],
      temperatureMax: json['temperatureMax'],
      temperatureMin: json['temperatureMin'],
      acidityMax: json['acidityMax'],
      acidityMin: json['acidityMin'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
