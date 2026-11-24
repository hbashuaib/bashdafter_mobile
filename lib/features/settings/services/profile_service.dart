import 'package:dio/dio.dart';

import '../../auth/models/user_profile.dart';
import '../../../core/api/api_client.dart';

class ProfileService {
  Future<UserProfile> getProfile() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/auth/profile/');

      return UserProfile.fromJson(response.data);
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected profile loading error');
    }
  }
}
