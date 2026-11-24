class InventoryTransactionModel {
  final int id;

  final int product;

  final String productName;

  final String transactionType;

  final String quantity;

  final String reference;

  final String createdAt;

  InventoryTransactionModel({
    required this.id,
    required this.product,
    required this.productName,
    required this.transactionType,
    required this.quantity,
    required this.reference,
    required this.createdAt,
  });

  factory InventoryTransactionModel.fromJson(Map<String, dynamic> json) {
    return InventoryTransactionModel(
      id: json['id'] ?? 0,

      product: json['product'] ?? 0,

      productName: json['product_name'] ?? '',

      transactionType: json['transaction_type'] ?? '',

      quantity: json['quantity']?.toString() ?? '0',

      reference: json['reference'] ?? '',

      createdAt: json['created_at'] ?? '',
    );
  }
}
