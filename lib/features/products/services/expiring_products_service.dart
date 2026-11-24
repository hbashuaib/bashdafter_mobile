import 'package:dio/dio.dart';

import '../../products/models/product_model.dart';
import '../../../core/api/api_client.dart';

class ExpiringProductsService {
  Future<List<ProductModel>> getExpiringProducts() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/products/expiring/');

      return (response.data as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected expiring products error');
    }
  }
}
