class RecentTransactionModel {
  final String type;

  final String customer;

  final num amount;

  final String date;

  RecentTransactionModel({
    required this.type,
    required this.customer,
    required this.amount,
    required this.date,
  });

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecentTransactionModel(
      type: json['type'] ?? '',

      customer: json['customer'] ?? '',

      amount: json['amount'] ?? 0,

      date: json['date'] ?? '',
    );
  }
}
