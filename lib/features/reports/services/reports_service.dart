import 'package:dio/dio.dart';

import '../models/customer_summary_model.dart';
import '../models/top_debtor_model.dart';
import '../models/recent_transaction_model.dart';
import '../../../core/api/api_client.dart';

class ReportsService {
  Future<List<CustomerSummaryModel>> getCustomerSummary() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/reports/customer-summary/');

      return (response.data as List)
          .map((item) => CustomerSummaryModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer summary loading error');
    }
  }

  Future<List<TopDebtorModel>> getTopDebtors() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/reports/top-debtors/');

      return (response.data as List)
          .map((item) => TopDebtorModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected top debtors loading error');
    }
  }

  Future<List<RecentTransactionModel>> getRecentTransactions() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/reports/recent-transactions/');

      return (response.data as List)
          .map((item) => RecentTransactionModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected recent transactions loading error');
    }
  }
}
