class DashboardTransactionModel {
  final String customer;

  final num amount;

  final String date;

  DashboardTransactionModel({
    required this.customer,
    required this.amount,
    required this.date,
  });

  factory DashboardTransactionModel.fromJson(Map<String, dynamic> json) {
    return DashboardTransactionModel(
      customer: json['customer'] ?? '',
      amount: json['amount'] ?? 0,
      date: json['date'] ?? '',
    );
  }
}
