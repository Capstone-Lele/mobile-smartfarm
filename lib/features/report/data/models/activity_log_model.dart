import 'package:budidaya_lele_mobile/features/report/domain/entities/activity_log.dart';

class ActivityLogModel extends ActivityLog {
  ActivityLogModel({
    required super.id,
    required super.userId,
    required super.noteId,
    required super.userName,
    required super.poolName,
    required super.activity,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'],
      userId: json['userId'],
      noteId: json['noteId'],
      userName: json['userName'],
      poolName: json['poolName'],
      activity: json['activity'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
