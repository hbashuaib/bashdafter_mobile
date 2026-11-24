import 'package:dio/dio.dart';

import '../models/payment_model.dart';
import '../../../core/api/api_client.dart';

class PaymentService {
  Future<List<PaymentModel>> getPayments() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/payments/');

      return (response.data as List)
          .map((item) => PaymentModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected payment loading error');
    }
  }
}
