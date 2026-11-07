import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class ProfileService {
  Future<Map<String, dynamic>> getProfile() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/auth/profile/',);

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected profile loading error');
    }
  }
}
