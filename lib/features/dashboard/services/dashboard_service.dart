import 'package:dio/dio.dart';

import '../models/dashboard_model.dart';
import '../../../core/api/api_client.dart';

class DashboardService {
  Future<DashboardModel> getDashboard() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/dashboard/');

      return DashboardModel.fromJson(response.data);
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected dashboard loading error');
    }
  }
}
