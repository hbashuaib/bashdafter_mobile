import 'package:dio/dio.dart';

import '../models/inventory_transaction_model.dart';
import '../../../core/api/api_client.dart';

class InventoryTransactionService {
  Future<List<InventoryTransactionModel>> getTransactions() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/inventory-transactions/');

      return (response.data as List)
          .map((item) => InventoryTransactionModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected inventory transaction loading error');
    }
  }
}
