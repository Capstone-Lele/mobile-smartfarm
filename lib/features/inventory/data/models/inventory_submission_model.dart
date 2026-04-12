import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission.dart';

class InventorySubmissionModel extends InventorySubmission {
  InventorySubmissionModel({
    required super.id,
    required super.userId,
    required super.user,
    required super.inventoryId,
    required super.product,
    required super.category,
    required super.quantity,
    required super.unit,
    required super.status,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory InventorySubmissionModel.fromJson(Map<String, dynamic> json) {
    return InventorySubmissionModel(
      id: json['id'],
      userId: json['userId'],
      user: json['user'],
      inventoryId: json['inventoryId'],
      product: json['product'],
      category: json['category'],
      quantity: json['quantity'],
      unit: json['unit'],
      status: json['status'],
      notes: json['notes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
