import 'package:equatable/equatable.dart';

class Pool extends Equatable {
  final String? cycleId;
  final String? cycle;
  final String? cycleStartDate;
  final String? cycleEndDate;
  final int? currentQuantity;
  final String? image;
  final int mortality;
  final int movedQuantity;
  final String id;
  final String name;
  final String category;
  final String? diameter;
  final String? length;
  final String? width;
  final String? height;
  final List<double> temperatureMax;
  final List<double> temperatureNormal;
  final List<double> temperatureMin;
  final List<double> acidityMax;
  final List<double> acidityNormal;
  final List<double> acidityMin;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  const Pool({
    required this.cycleId,
    required this.cycle,
    required this.cycleStartDate,
    required this.cycleEndDate,
    required this.currentQuantity,
    required this.image,
    required this.mortality,
    required this.movedQuantity,
    required this.id,
    required this.name,
    required this.category,
    required this.diameter,
    required this.length,
    required this.width,
    required this.height,
    required this.temperatureMax,
    required this.temperatureNormal,
    required this.temperatureMin,
    required this.acidityMax,
    required this.acidityNormal,
    required this.acidityMin,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  String get categoryLabel {
    switch (category) {
      case 'growing':
        return 'Pembesaran';
      case 'breeding':
        return 'Pembenihan';
      case 'quarantine':
        return 'Karantina';
      default:
        return 'Category Tidak Diketahui';
    }
  }

  @override
  List<Object?> get props => [id];
}
