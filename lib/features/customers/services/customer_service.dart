import 'package:dio/dio.dart';

import '../models/customer_model.dart';
import '../../../core/api/api_client.dart';

class CustomerService {
  Future<List<CustomerModel>> getCustomers() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/customers/');

      return (response.data as List)
          .map((item) => CustomerModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer loading error');
    }
  }
}
