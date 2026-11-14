import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class UnitService {
  Future<List<dynamic>> getUnits() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/units/');

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected unit loading error');
    }
  }

  Future<void> createUnit({
    required String name,
    required String description,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post(
        '/units/',
        data: {'name': name.trim(), 'description': description.trim()},
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected unit creation error');
    }
  }

  Future<void> updateUnit({
    required int id,
    required String name,
    required String description,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.put(
        '/units/$id/',
        data: {'name': name.trim(), 'description': description.trim()},
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected unit update error');
    }
  }

  Future<void> deleteUnit(int id) async {
    final dio = await ApiClient.instance;

    try {
      await dio.delete('/units/$id/');
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected unit delete error');
    }
  }
}
