import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';

class ScheduleModel extends Schedule {
  ScheduleModel({
    required super.id,
    required super.poolName,
    required super.userName,
    required super.scheduleDate,
    required super.type,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      poolName: json['poolName'],
      userName: json['userName'],
      scheduleDate: json['scheduleDate'],
      type: json['type'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
