class PoolDetail {
  final String? cycleId;
  final String? cycle;
  final int? currentQuantity;
  final String? image;
  final String id;
  final String name;
  final String category;
  final String? diameter;
  final String? length;
  final String? width;
  final String? height;
  final String temperatureMax;
  final String temperatureMin;
  final String acidityMax;
  final String acidityMin;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  PoolDetail({
    required this.cycleId,
    required this.cycle,
    required this.currentQuantity,
    required this.image,
    required this.id,
    required this.name,
    required this.category,
    required this.diameter,
    required this.length,
    required this.width,
    required this.height,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.acidityMax,
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

  String get cycleLabel {
    switch (cycle) {
      case 'transfer':
        return 'Pindah';
      case 'harvest':
        return 'Panen';
      case 'active_cultivation':
        return 'Aktif Budidaya';
      default:
        return 'Cycle Tidak Diketahui';
    }
  }
}
