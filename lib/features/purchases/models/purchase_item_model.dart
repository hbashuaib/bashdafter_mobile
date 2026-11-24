class PurchaseItemModel {
  final int id;
  final int purchase;

  final int? product;

  final String productName;
  final String itemName;

  final String quantity;
  final String unitPrice;
  final String totalPrice;

  PurchaseItemModel({
    required this.id,
    required this.purchase,
    this.product,
    required this.productName,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemModel(
      id: json['id'] ?? 0,
      purchase: json['purchase'] ?? 0,

      product: json['product'],

      productName: json['product_name'] ?? '',
      itemName: json['item_name'] ?? '',

      quantity: json['quantity']?.toString() ?? '0',
      unitPrice: json['unit_price']?.toString() ?? '0',
      totalPrice: json['total_price']?.toString() ?? '0',
    );
  }
}
