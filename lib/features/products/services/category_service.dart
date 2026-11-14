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

  Future<void> createCategory({
    required String name,
    required String description,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post(
        '/categories/',
        data: {'name': name.trim(), 'description': description.trim()},
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected category creation error');
    }
  }

  Future<void> updateCategory({
    required int id,
    required String name,
    required String description,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.put(
        '/categories/$id/',
        data: {'name': name.trim(), 'description': description.trim()},
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected category update error');
    }
  }

  Future<void> deleteCategory(int id) async {
    final dio = await ApiClient.instance;

    try {
      await dio.delete('/categories/$id/');
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected category delete error');
    }
  }
}
