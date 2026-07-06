import 'package:budidaya_lele_mobile/features/schedule/domain/entities/auto_fill.dart';

class AutoFillModel extends AutoFill {
  AutoFillModel({
    required super.id,
    required super.name,
    required super.deletedAt,
  });

  factory AutoFillModel.fromJson(Map<String, dynamic> json) {
    return AutoFillModel(
      id: json['id'],
      name: json['name'],
      deletedAt: json['deletedAt'],
    );
  }
}
