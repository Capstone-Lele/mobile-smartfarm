import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';

class PoolModel extends Pool {
  PoolModel({
    required super.cycleId,
    required super.cycle,
    required super.cycleStartDate,
    required super.cycleEndDate,
    required super.currentQuantity,
    required super.image,
    required super.mortality,
    required super.movedQuantity,
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

  factory PoolModel.fromJson(Map<String, dynamic> json) {
    return PoolModel(
      cycleId: json['cycleId'],
      cycle: json['cycle'],
      cycleStartDate: json['cycleStartDate'],
      cycleEndDate: json['cycleEndDate'],
      currentQuantity: json['currentQuantity'],
      image: json['image'],
      mortality: json['mortality'],
      movedQuantity: json['movedQuantity'],
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
