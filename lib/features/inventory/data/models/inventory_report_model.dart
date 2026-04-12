import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report.dart';

class InventoryReportModel extends InventoryReport {
  InventoryReportModel({
    required super.id,
    required super.inventoryId,
    required super.product,
    required super.reportDate,
    required super.quantity,
    required super.unit,
    required super.image,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory InventoryReportModel.fromJson(Map<String, dynamic> json) {
    return InventoryReportModel(
      id: json['id'],
      inventoryId: json['inventoryId'],
      product: json['product'],
      reportDate: json['reportDate'],
      quantity: json['quantity'],
      unit: json['unit'],
      image: json['image'],
      notes: json['notes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
