import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class InventoryTransactionService {
  Future<List<dynamic>> getTransactions() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/inventory-transactions/',
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected inventory transaction loading error');
    }
  }
}
