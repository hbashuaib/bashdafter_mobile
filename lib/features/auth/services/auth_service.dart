import 'package:dio/dio.dart';

import '../models/user_profile.dart';
import '../../../core/api/api_client.dart';

class AuthService {
  Future<Response> login({
    required String username,
    required String password,
  }) async {
    try {
      final dio = await ApiClient.instance;
      return await dio.post(
        '/auth/login/',

        data: {'username': username, 'password': password},
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected login error');
    }
  }

  Future<UserProfile> getProfile() async {
    final dio = await ApiClient.instance;

    final response = await dio.get('/auth/profile/');

    return UserProfile.fromJson(response.data);
  }
}
