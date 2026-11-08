import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class ChangePasswordService {
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post(
        '/auth/change-password/',
        data: {'old_password': oldPassword, 'new_password': newPassword},
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected password change error');
    }
  }
}
