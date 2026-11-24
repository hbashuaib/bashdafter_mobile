class PaymentModel {
  final int id;

  final int customer;

  final String customerName;
  final String shopName;

  final String amount;
  final String paymentDate;
  final String notes;

  final String createdAt;

  PaymentModel({
    required this.id,
    required this.customer,
    required this.customerName,
    required this.shopName,
    required this.amount,
    required this.paymentDate,
    required this.notes,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? 0,

      customer: json['customer'] ?? 0,

      customerName: json['customer_name'] ?? '',
      shopName: json['shop_name'] ?? '',

      amount: json['amount']?.toString() ?? '0',

      paymentDate: json['payment_date'] ?? '',

      notes: json['notes'] ?? '',

      createdAt: json['created_at'] ?? '',
    );
  }
}
