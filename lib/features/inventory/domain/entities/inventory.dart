import 'package:equatable/equatable.dart';

class Inventory extends Equatable {
  final String id;
  final String productId;
  final String product;
  final String categoryId;
  final String category;
  final String unitId;
  final String unit;
  final String totalQuantity;
  final String minQuantity;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  const Inventory({
    required this.id,
    required this.productId,
    required this.product,
    required this.categoryId,
    required this.category,
    required this.unitId,
    required this.unit,
    required this.totalQuantity,
    required this.minQuantity,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  @override
  List<Object?> get props => [id];
}
