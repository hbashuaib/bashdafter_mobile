import 'dashboard_top_debtor_model.dart';
import 'dashboard_transaction_model.dart';

class DashboardModel {
  final int customers;

  final num totalPurchases;

  final num totalPayments;

  final num totalBalance;

  final List<DashboardTopDebtorModel> topDebtors;

  final List<DashboardTransactionModel> recentPurchases;

  final List<DashboardTransactionModel> recentPayments;

  DashboardModel({
    required this.customers,
    required this.totalPurchases,
    required this.totalPayments,
    required this.totalBalance,
    required this.topDebtors,
    required this.recentPurchases,
    required this.recentPayments,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      customers: json['customers'] ?? 0,

      totalPurchases: json['total_purchases'] ?? 0,

      totalPayments: json['total_payments'] ?? 0,

      totalBalance: json['total_balance'] ?? 0,

      topDebtors: (json['top_debtors'] as List<dynamic>? ?? [])
          .map((item) => DashboardTopDebtorModel.fromJson(item))
          .toList(),

      recentPurchases: (json['recent_purchases'] as List<dynamic>? ?? [])
          .map((item) => DashboardTransactionModel.fromJson(item))
          .toList(),

      recentPayments: (json['recent_payments'] as List<dynamic>? ?? [])
          .map((item) => DashboardTransactionModel.fromJson(item))
          .toList(),
    );
  }
}
