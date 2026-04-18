import 'package:budidaya_lele_mobile/features/inventory/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }
}
