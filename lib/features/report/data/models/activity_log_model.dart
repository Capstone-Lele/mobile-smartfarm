import 'package:budidaya_lele_mobile/features/report/domain/entities/activity_log.dart';

class ActivityLogModel extends ActivityLog {
  ActivityLogModel({
    required super.id,
    required super.reportId,
    required super.user,
    required super.poolName,
    required super.activity,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'],
      reportId: json['reportId'],
      user: json['user'],
      poolName: json['poolName'],
      activity: json['activity'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}


