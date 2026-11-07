import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class InventoryDashboardService {
  Future<Map<String, dynamic>> getDashboard() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/inventory-dashboard/',
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected inventory dashboard loading error');
    }
  }
}
