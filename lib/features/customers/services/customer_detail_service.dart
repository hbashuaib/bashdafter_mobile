import 'package:dio/dio.dart';

import '../models/customer_model.dart';
import '../../../core/api/api_client.dart';

class CustomerDetailService {
  Future<CustomerModel> getCustomer(int id) async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/customers/$id/');

      return CustomerModel.fromJson(response.data);
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer detail loading error');
    }
  }
}
