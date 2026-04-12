class SickReportDetail {
  final String originPoolName;
  final String originCategory;
  final String destinationPoolName;
  final String destinationCategory;
  final String user;
  final String startDate;
  final String id;
  final String originCycleId;
  final String destinationCycleId;
  final String userId;
  final String reportDate;
  final int quantity;
  final String image;
  final String type;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  SickReportDetail({
    required this.originPoolName,
    required this.originCategory,
    required this.destinationPoolName,
    required this.destinationCategory,
    required this.user,
    required this.startDate,
    required this.id,
    required this.originCycleId,
    required this.destinationCycleId,
    required this.userId,
    required this.reportDate,
    required this.quantity,
    required this.image,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  String get originCategoryLabel {
    switch (originCategory) {
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

  String get destinationCategoryLabel {
    switch (destinationCategory) {
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
}
