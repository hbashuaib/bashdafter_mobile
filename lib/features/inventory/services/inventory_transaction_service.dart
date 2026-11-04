import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class InventoryTransactionService {
  Future<List<dynamic>> getTransactions() async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().get(
      '${ApiConstants.baseUrl}/inventory-transactions/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }
}
