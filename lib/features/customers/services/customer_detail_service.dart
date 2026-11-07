import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class CustomerDetailService {
  Future<Map<String, dynamic>> getCustomer(int id) async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/customers/$id/');

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer detail loading error');
    }
  }
}
