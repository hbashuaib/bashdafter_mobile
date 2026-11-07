import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class CustomerStatementService {
  Future<Map<String, dynamic>> getStatement(int customerId) async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/reports/customer-statement/$customerId/',
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer statement loading error');
    }
  }
}
