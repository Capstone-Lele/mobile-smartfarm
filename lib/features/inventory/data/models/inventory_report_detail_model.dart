import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report_detail.dart';

class InventoryReportDetailModel extends InventoryReportDetail {
  InventoryReportDetailModel({
    required super.id,
    required super.userId,
    required super.user,
    required super.product,
    required super.inventoryId,
    required super.reportDate,
    required super.quantity,
    required super.type,
    required super.transactionType,
    required super.image,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory InventoryReportDetailModel.fromJson(Map<String, dynamic> json) {
    return InventoryReportDetailModel(
      id: json['id'],
      userId: json['userId'],
      user: json['user'],
      product: json['product'],
      inventoryId: json['inventoryId'],
      reportDate: json['reportDate'],
      quantity: json['quantity'],
      type: json['type'],
      transactionType: json['transaction_type'],
      image: json['image'],
      notes: json['notes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
