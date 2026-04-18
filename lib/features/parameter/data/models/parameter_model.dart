import 'package:budidaya_lele_mobile/features/parameter/domain/entities/parameter.dart';

class ParameterModel extends Parameter {
  ParameterModel({
    required super.temperatureMax,
    required super.temperatureMin,
    required super.acidityMax,
    required super.acidityMin,
  });

  factory ParameterModel.fromJson(Map<String, dynamic> json) {
    return ParameterModel(
      temperatureMax: json['temperatureMax'],
      temperatureMin: json['temperatureMin'],
      acidityMax: json['acidityMax'],
      acidityMin: json['acidityMin'],
    );
  }
}
