import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class InactiveProductService {
  Future<List<dynamic>> getInactiveProducts() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/products/inactive/');

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected inactive product loading error');
    }
  }

  Future<void> restoreProduct(int productId) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post('/products/$productId/restore/');
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected product restore error');
    }
  }
}
