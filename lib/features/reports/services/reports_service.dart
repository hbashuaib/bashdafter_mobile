import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class ReportsService {
  Future<List<dynamic>> getCustomerSummary() async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().get(
      '${ApiConstants.baseUrl}/reports/customer-summary/',

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }

  Future<List<dynamic>> getTopDebtors() async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().get(
      '${ApiConstants.baseUrl}/reports/top-debtors/',

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }

  Future<List<dynamic>> getRecentTransactions() async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().get(
      '${ApiConstants.baseUrl}/reports/recent-transactions/',

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }
}
