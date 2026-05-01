import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';

class PoolDetailModel extends PoolDetail {
  PoolDetailModel({
    required super.cycleId,
    required super.cycle,
    required super.currentQuantity,
    required super.image,
    required super.id,
    required super.name,
    required super.category,
    required super.diameter,
    required super.length,
    required super.width,
    required super.height,
    required super.temperatureMax,
    required super.temperatureNormal,
    required super.temperatureMin,
    required super.acidityMax,
    required super.acidityNormal,
    required super.acidityMin,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory PoolDetailModel.fromJson(Map<String, dynamic> json) {
    return PoolDetailModel(
      cycleId: json['cycleId'],
      cycle: json['cycle'],
      currentQuantity: json['currentQuantity'],
      image: json['image'],
      id: json['id'],
      name: json['name'],
      category: json['category'],
      diameter: json['diameter'],
      length: json['length'],
      width: json['width'],
      height: json['height'],
      temperatureMax:
          (json['temperatureMax'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      temperatureNormal:
          (json['temperatureNormal'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      temperatureMin:
          (json['temperatureMin'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      acidityMax:
          (json['acidityMax'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      acidityNormal:
          (json['acidityNormal'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      acidityMin:
          (json['acidityMin'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
