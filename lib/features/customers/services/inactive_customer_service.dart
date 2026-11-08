import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class InactiveCustomerService {
  Future<List<dynamic>> getInactiveCustomers() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/customers/inactive/');

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected inactive customer loading error');
    }
  }

  Future<void> restoreCustomer(int customerId) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post('/customers/$customerId/restore/');
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer restore error');
    }
  }
}
