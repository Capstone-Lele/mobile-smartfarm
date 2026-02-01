class Pool {
  final String id;
  final String name;
  final String category;
  final String? diameter;
  final String? length;
  final String? width;
  final String temperatureMax;
  final String temperatureMin;
  final String acidityMax;
  final String acidityMin;
  final String createdAt;
  final String updatedAt;

  Pool({
    required this.id,
    required this.name,
    required this.category,
    required this.diameter,
    required this.length,
    required this.width,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.acidityMax,
    required this.acidityMin,
    required this.createdAt,
    required this.updatedAt,
  });
}
