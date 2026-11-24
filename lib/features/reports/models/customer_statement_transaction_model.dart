class CustomerStatementTransactionModel {
  final int id;

  final String type;
  final String date;

  final num amount;
  final num runningBalance;

  CustomerStatementTransactionModel({
    required this.id,
    required this.type,
    required this.date,
    required this.amount,
    required this.runningBalance,
  });

  factory CustomerStatementTransactionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerStatementTransactionModel(
      id: json['id'] ?? 0,

      type: json['type'] ?? '',
      date: json['date'] ?? '',

      amount: json['amount'] ?? 0,

      runningBalance: json['running_balance'] ?? 0,
    );
  }
}
