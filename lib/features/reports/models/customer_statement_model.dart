import 'customer_statement_transaction_model.dart';

class CustomerStatementModel {
  final String customer;
  final String phone;
  final String shopName;

  final num balance;

  final List<CustomerStatementTransactionModel>
      transactions;

  CustomerStatementModel({
    required this.customer,
    required this.phone,
    required this.shopName,
    required this.balance,
    required this.transactions,
  });

  factory CustomerStatementModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerStatementModel(
      customer: json['customer'] ?? '',

      phone: json['phone'] ?? '',

      shopName: json['shop_name'] ?? '',

      balance: json['balance'] ?? 0,

      transactions:
          (json['transactions'] as List<dynamic>? ??
                  [])
              .map(
                (item) =>
                    CustomerStatementTransactionModel
                        .fromJson(item),
              )
              .toList(),
    );
  }
}