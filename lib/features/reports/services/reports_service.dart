import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class ReportsService {
  Future<List<dynamic>> getCustomerSummary() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/reports/customer-summary/',
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer summary loading error');
    }
  }

  Future<List<dynamic>> getTopDebtors() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/reports/top-debtors/',
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected top debtors loading error');
    }
  }

  Future<List<dynamic>> getRecentTransactions() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/reports/recent-transactions/',
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected recent transactions loading error');
    }
  }
}
