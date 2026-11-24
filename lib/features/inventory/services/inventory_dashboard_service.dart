import 'package:dio/dio.dart';

import '../models/inventory_dashboard_model.dart';

import '../../../core/api/api_client.dart';

class InventoryDashboardService {
  Future<InventoryDashboardModel> getDashboard() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/inventory-dashboard/');

      return InventoryDashboardModel.fromJson(response.data);
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected inventory dashboard loading error');
    }
  }
}
