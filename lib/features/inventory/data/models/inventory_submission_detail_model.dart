import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission_detail.dart';

class InventorySubmissionDetailModel extends InventorySubmissionDetail {
  InventorySubmissionDetailModel({
    required super.id,
    required super.userId,
    required super.user,
    required super.inventoryId,
    required super.product,
    required super.category,
    required super.quantity,
    required super.unit,
    required super.status,
    required super.feedback,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory InventorySubmissionDetailModel.fromJson(Map<String, dynamic> json) {
    return InventorySubmissionDetailModel(
      id: json['id'],
      userId: json['userId'],
      user: json['user'],
      inventoryId: json['inventoryId'],
      product: json['product'],
      category: json['category'],
      quantity: json['quantity'],
      unit: json['unit'],
      status: json['status'],
      feedback: json['feedback'],
      notes: json['notes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
