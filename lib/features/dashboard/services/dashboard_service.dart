import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class DashboardService {
  Future<Map<String, dynamic>> getDashboard() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/dashboard/');

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected dashboard loading error');
    }
  }
}
