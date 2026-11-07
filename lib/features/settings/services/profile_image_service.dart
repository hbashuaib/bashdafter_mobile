import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class ProfileImageService {
  Future<void> uploadImage(String imagePath) async {
    final dio = await ApiClient.instance;

    try {
      final formData = FormData.fromMap({
        'profile_image': await MultipartFile.fromFile(imagePath),
      });

      await dio.post('/auth/profile/upload-image/', data: formData);
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected profile image upload error');
    }
  }
}
