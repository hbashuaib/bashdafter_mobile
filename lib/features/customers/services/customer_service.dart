import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class CustomerService {
  Future<List<dynamic>> getCustomers() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/customers/');

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer loading error');
    }
  }
}
