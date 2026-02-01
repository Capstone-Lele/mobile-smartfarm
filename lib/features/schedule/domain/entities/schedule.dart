class Schedule {
  final String id;
  final String poolName;
  final String userName;
  final String scheduleDate;
  final String type;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Schedule({
    required this.id,
    required this.poolName,
    required this.userName,
    required this.scheduleDate,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  String get typeLabel {
    switch (type) {
      case 'cleaning':
        return 'Pembersihan Kolam';
      case 'feeding':
        return 'Pemberian Pakan';
      case 'sampling':
        return 'Pengambilan Sampling';
      default:
        return 'Jenis Tidak Diketahui';
    }
  }

  DateTime get scheduleDateParsed {
    return DateTime.parse(scheduleDate);
  }
}
