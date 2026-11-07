import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class CategoryService {
  Future<List<dynamic>> getCategories() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/categories/');

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected category loading error');
    }
  }
}
