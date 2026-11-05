import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class InventoryTransactionService {
  Future<List<dynamic>> getTransactions() async {
    final token = await TokenStorage.getAccessToken();

    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/inventory-transactions/',

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected inventory transaction loading error');
    }
  }
}
