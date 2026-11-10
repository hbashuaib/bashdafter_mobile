import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class BarcodeLookupService {
  Future<Map<String, dynamic>> findProductByBarcode(String barcode) async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/products/barcode/',
        queryParameters: {'barcode': barcode},
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Barcode lookup failed');
    }
  }
}
