import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class PurchaseService {
  Future<List<dynamic>> getPurchases() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/purchases/',
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected purchase loading error');
    }
  }
}
