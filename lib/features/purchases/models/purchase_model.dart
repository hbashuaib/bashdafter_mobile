import 'purchase_item_model.dart';

class PurchaseModel {
  final int id;

  final int customer;

  final String customerName;
  final String shopName;

  final String purchaseDate;
  final String totalAmount;
  final String notes;

  final String createdAt;
  final String updatedAt;

  final List<PurchaseItemModel> items;

  PurchaseModel({
    required this.id,
    required this.customer,
    required this.customerName,
    required this.shopName,
    required this.purchaseDate,
    required this.totalAmount,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'] ?? 0,

      customer: json['customer'] ?? 0,

      customerName: json['customer_name'] ?? '',
      shopName: json['shop_name'] ?? '',

      purchaseDate: json['purchase_date'] ?? '',
      totalAmount: json['total_amount']?.toString() ?? '0',

      notes: json['notes'] ?? '',

      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',

      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => PurchaseItemModel.fromJson(item))
          .toList(),
    );
  }
}
