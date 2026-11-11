import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class ExpiringProductsService {
  Future<List<dynamic>> getExpiringProducts() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/products/expiring/');

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected expiring products error');
    }
  }
}
