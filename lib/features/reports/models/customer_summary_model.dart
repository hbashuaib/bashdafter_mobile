class CustomerSummaryModel {
  final int id;

  final String name;
  final String phone;

  final num totalPurchases;
  final num totalPayments;
  final num balance;

  CustomerSummaryModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.totalPurchases,
    required this.totalPayments,
    required this.balance,
  });

  factory CustomerSummaryModel.fromJson(Map<String, dynamic> json) {
    return CustomerSummaryModel(
      id: json['id'] ?? 0,

      name: json['name'] ?? '',
      phone: json['phone'] ?? '',

      totalPurchases: json['total_purchases'] ?? 0,
      totalPayments: json['total_payments'] ?? 0,
      balance: json['balance'] ?? 0,
    );
  }
}
