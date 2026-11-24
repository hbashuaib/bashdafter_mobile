import 'package:dio/dio.dart';

import '../models/top_selling_product_model.dart';
import '../../../core/api/api_client.dart';

class TopSellingProductsService {
  Future<List<TopSellingProductModel>> getProducts() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/top-selling-products/');

      return (response.data as List)
          .map((item) => TopSellingProductModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected top selling products loading error');
    }
  }
}
