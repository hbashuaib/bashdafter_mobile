import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<Response> login({
    required String username,
    required String password,
  }) async {
    try {
      return await _dio.post(
        '${ApiConstants.baseUrl}/auth/login/',

        data: {'username': username, 'password': password},
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected login error');
    }
  }
}
