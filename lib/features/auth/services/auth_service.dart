import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<Response> login({
    required String username,
    required String password,
  }) async {

    return await _dio.post(
      '${ApiConstants.baseUrl}/auth/login/',
      data: {
        'username': username,
        'password': password,
      },
    );
  }
}
