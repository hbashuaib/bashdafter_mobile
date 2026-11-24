import 'package:dio/dio.dart';

import '../models/product_model.dart';
import '../../../core/api/api_client.dart';

class BarcodeLookupService {
  Future<ProductModel> findProductByBarcode(String barcode) async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/products/barcode/',
        queryParameters: {'barcode': barcode},
      );

      return ProductModel.fromJson(response.data);
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Barcode lookup failed');
    }
  }
}
