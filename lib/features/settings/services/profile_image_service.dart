import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class ProfileImageService {
  Future<void> uploadImage(String imagePath) async {
    final token = await TokenStorage.getAccessToken();

    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    try {
      final formData = FormData.fromMap({
        'profile_image': await MultipartFile.fromFile(imagePath),
      });

      await dio.post(
        '${ApiConstants.baseUrl}/auth/profile/upload-image/',

        data: formData,

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected profile image upload error');
    }
  }
}
