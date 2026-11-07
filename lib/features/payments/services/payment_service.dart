import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class PaymentService {
  Future<List<dynamic>> getPayments() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/payments/',
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected payment loading error');
    }
  }
}
