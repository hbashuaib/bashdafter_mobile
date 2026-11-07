import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class UnitService {
  Future<List<dynamic>> getUnits() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get(
        '/units/',        
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected unit loading error');
    }
  }
}
