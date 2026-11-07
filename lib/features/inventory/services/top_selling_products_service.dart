import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class TopSellingProductsService {
  Future<List<dynamic>> getProducts() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/top-selling-products/',
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected top selling products loading error');
    }
  }
}
